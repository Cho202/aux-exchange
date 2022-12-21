use aux_rs::client::{AuxClient, CoinClient, PoolClient};
use aux_rs::schema::{Coin, Coins, Curve, Percent, PoolInput};
use aux_rs::server::create_server;
use aux_rs::{decimal_units, publish};
use color_eyre::eyre::{eyre, Result};
use rust_decimal_macros::dec;
use serde::Deserialize;
use serde_json::json;
use std::time::Duration;
use sui_keys::keystore::{AccountKeystore, FileBasedKeystore, Keystore};
use sui_sdk::SuiClient;


#[tokio::test]
async fn test_graphql() -> Result<()> {
    color_eyre::install()?;

    let sui_client = SuiClient::new("http://127.0.0.1:9000", None, None)
        .await
        .map_err(|err| eyre!(err))?;

    let keystore = Keystore::from(
        FileBasedKeystore::new(
            &dirs::home_dir()
                .ok_or(eyre!("Failed to get home dir."))?
                .join(".sui")
                .join("sui_config")
                .join("sui.keystore"),
        )
        .map_err(|err| eyre!(err))?,
    );

    let signer = keystore.addresses().last().unwrap().to_owned();

    let package = publish(&sui_client, &keystore).await;
    println!("Package: {package:?}");

    let aux_client = AuxClient {
        sui_client,
        package,
    };

    let sui = "0x2::sui::SUI".to_string();
    let usdc = format!("{package}::test_usdc::TEST_USDC");

    let pool_input = PoolInput {
        coin_types: vec![sui.clone(), usdc.clone()],
        curve: Curve::ConstantProduct,
    };

    let tx = aux_client
        .mint_and_transfer(signer, &usdc, 400_000_000, signer)
        .await?;
    aux_client.sign_and_execute(&keystore, tx).await?;

    // GraphQL server
    let task = tokio::spawn(async move { create_server(package).await });
    tokio::time::sleep(Duration::from_millis(1000)).await;

    // GraphQL client
    let client = reqwest::Client::new();

    let res: GraphQLResponse<CreatePool> = client
        .post("http://devbox:4000/graphql")
        .json(&json!(
            {
                "query": "
                    mutation ($createPoolInput: CreatePoolInput!) {
                        createPool(createPoolInput: $createPoolInput) {
                            packageObjectId
                            module
                            function
                            typeArguments
                            arguments
                        }
                    }
                ",
                "variables": {
                    "createPoolInput": {
                        "sender": signer,
                        "feeTier": "MOST",
                        "poolInput": {
                            "coinTypes": [
                                sui,
                                usdc
                            ],
                            "curve": "CONSTANT_PRODUCT"
                        }
                    }
                }
            }
        ))
        .send()
        .await?
        .json()
        .await?;
    assert!(res.errors.is_none(), "{:?}", res.errors);
    println!("{res:?}");

    // let res: GraphQLResponse<CreatePool> = client
    //     .post("http://devbox:4000/graphql")
    //     .json(&json!(
    //         {
    //             "query": "
    //                 mutation ($addLiquidityInput: AddLiquidityInput!) {
    //                     createPool(addLiquidityInput: $addLiquidityInput)
    //                 }
    //             ",
    //             "variables": {
    //                 "addLiquidityInput": {
    //                     "sender": signer,
    //                     "feeTier": "MOST",
    //                     "poolInput": {
    //                         "coinTypes": [
    //                             sui,
    //                             usdc
    //                         ],
    //                         "curve": "CONSTANT_PRODUCT"
    //                     }
    //                 }
    //             }
    //         }
    //     ))
    //     .send()
    //     .await?
    //     .json()
    //     .await?;
    // assert!(res.errors.is_none(), "{:?}", res.errors);
    // println!("{res:?}");

    // let signature = keystore.sign(&signer, &res.data.unwrap().create_pool)?;
    // let tx = aux_client
    //     .create_pool(signer, &pool_input, FeeTier::Most)
    //     .await?;
    // assert_eq!(signature, keystore.sign(&signer, &tx.to_bytes())?);
    // aux_client.sign_and_execute(&keystore, tx).await?;
    let tx = aux_client
        .add_liquidity(
            signer,
            &pool_input,
            &[
                decimal_units(100_000_000_000, Coins::sui().0.decimals)?,
                decimal_units(400_000_000, Coins::usdc().0.decimals)?,
            ],
        )
        .await?;
    aux_client.sign_and_execute(&keystore, tx).await?;

    let tx = aux_client
        .swap_exact_in(
            signer,
            &pool_input,
            &sui,
            &usdc,
            decimal_units(100_000_000_000, Coins::sui().0.decimals)?,
            Percent(dec!(0.5)),
        )
        .await?;
    aux_client.sign_and_execute(&keystore, tx).await?;

    let res: GraphQLResponse<serde_json::Value> = client
        .post("http://devbox:4000/graphql")
        .json(&json!({"query": "
            {
                pools {
                    id
                    type
                    version
                    featured
                    coins {
                        id
                        decimals
                        name
                        symbol
                        description
                        iconUrl
                    }
                    curve
                    reserves
                    supplyLp
                    feeTier
                    fee
                    swaps {
                        coinIn {
                            id
                            decimals
                            name
                            symbol
                            description
                            iconUrl
                        }
                        coinOut {
                            id
                            decimals
                            name
                            symbol
                            description
                            iconUrl
                        }
                        amountIn
                        amountOut
                        sender
                        timestamp
                    }
                    adds {
                        amountsAdded
                        amountMintedLp
                        sender
                        timestamp
                    }
                    removes {
                        amountsRemoved
                        amountBurnedLp
                        sender
                        timestamp
                    }
                    summaryStatistics {
                        tvl
                        volume24h
                        fee24h
                        userCount24h
                        transactionCount24h
                        volume1w
                        fee1w
                        userCount1w
                        transactionCount1w
                    }
                }
            }
        "}))
        .send()
        .await?
        .json()
        .await?;
    assert!(res.errors.is_none(), "{:?}", res.errors);
    println!(
        "{}",
        serde_json::to_string_pretty(&res.data.unwrap()).unwrap()
    );

    task.abort();

    Ok(())
}

#[derive(Debug, Deserialize)]
struct GraphQLResponse<T> {
    pub data: Option<T>,
    pub errors: Option<serde_json::Value>,
}

#[derive(Debug, Deserialize)]
struct Pool {
    pub id: String,
    pub type_: String,
    pub coins: Vec<Coin>,
    pub amounts: Vec<u64>,
}

#[derive(Debug, Deserialize)]
struct CreatePool {
    #[serde(rename = "createPool")]
    pub create_pool: Vec<u8>,
}
