// Autogenerated from ./docs/concliq/gen-math -p 64
// Manual edit with caution.
//
// Tick math for concentrated liquidity.
// square price is an u128 used as a fixed point number.
// Precision indicates how many bits are after decimal point.
// There are three optiosn for precision:
// - 32: only lower 64 bits of the u128 is used, decimal point is at index 96 of the u128 from the most significant bit.
// - 64: only lower 96 bits of the u128 is used, decimal point is at index 64 of the u128 from the most significant bit.
// - 96: all the bits of the u128 is used, decimal point is at index 32 of teh u128 from the most significant bit.
module aux::concliq_math {
    use aux::uint256;
    use aux::int64::{Self, Int64};
    use aux::int128::{Self, Int128};

    /**********************/
    /* Errors             */
    /**********************/

    const E_TICK_TOO_BIG: u64 = 1001;
    const E_TICK_TOO_SMALL: u64 = 1002;
    const E_Y_OUTSIDE_1_2: u64 = 1003;
    const E_ZERO_FOR_LOG_2: u64 = 1004;
    const E_Y_LESS_THAN_ONE: u64 = 1004;

    /**********************/
    /* constants          */
    /**********************/

    /// Precision used in the operation.
    const PRECISION: u8 = 64;

    const OFFSET_96: u8 = 96 - 64;

    const ONE_X: u128 = 1 << 64;
    const TWO_X: u128 = 1 << (64 + 1);

    /// sqrt(1.0001) in fixed point 64
    const SQUARE_PRICE: u128 = 18447666387855959850;
    /// log_2 sqrt(1.0001) in fixed point 64
    const SQUARE_PRICE_LOG_2: u128 = 1330584781654113;
    /// 1/sqrt(1.0001)
    const SQUARE_PRICE_NEG: u128 = 18445821805675392311;
    /// log_2 1/sqrt(1.0001)
    const SQUARE_PRICE_NEG_LOG_2_ABS: u128 = 1330584781654116;

    /// get sqrt(1.0001)^i
    public fun get_square_price_from_tick(i: Int64): u128 {
        if (int64::is_negative(i)) {
            get_square_price_from_tick_negative(int64::abs(i))
        } else {
            get_square_price_from_tick_positive(int64::raw_value(i))
        }
    }

    /// get sqrt(1.0001)^i, where i >= 0
    public fun get_square_price_from_tick_positive(i: u64): u128 {
        assert!(i <= 443636, E_TICK_TOO_BIG);
        let r = uint256::new(0, ONE_X);

        // check for 2^0
        if (i & 1 > 0) {
            r = uint256::multiply_underlying(r, 18447666387855959850);
            r = uint256::rsh(r, PRECISION);
        };

        // check for 2^1
        if (i & 2 > 0) {
            r = uint256::multiply_underlying(r, 18448588748116922571);
            r = uint256::rsh(r, PRECISION);
        };

        // check for 2^2
        if (i & 4 > 0) {
            r = uint256::multiply_underlying(r, 18450433606991734263);
            r = uint256::rsh(r, PRECISION);
        };

        // check for 2^3
        if (i & 8 > 0) {
            r = uint256::multiply_underlying(r, 18454123878217468680);
            r = uint256::rsh(r, PRECISION);
        };

        // check for 2^4
        if (i & 16 > 0) {
            r = uint256::multiply_underlying(r, 18461506635090006701);
            r = uint256::rsh(r, PRECISION);
        };

        // check for 2^5
        if (i & 32 > 0) {
            r = uint256::multiply_underlying(r, 18476281010653910144);
            r = uint256::rsh(r, PRECISION);
        };

        // check for 2^6
        if (i & 64 > 0) {
            r = uint256::multiply_underlying(r, 18505865242158250041);
            r = uint256::rsh(r, PRECISION);
        };

        // check for 2^7
        if (i & 128 > 0) {
            r = uint256::multiply_underlying(r, 18565175891880433522);
            r = uint256::rsh(r, PRECISION);
        };

        // check for 2^8
        if (i & 256 > 0) {
            r = uint256::multiply_underlying(r, 18684368066214940582);
            r = uint256::rsh(r, PRECISION);
        };

        // check for 2^9
        if (i & 512 > 0) {
            r = uint256::multiply_underlying(r, 18925053041275764671);
            r = uint256::rsh(r, PRECISION);
        };

        // check for 2^10
        if (i & 1024 > 0) {
            r = uint256::multiply_underlying(r, 19415764168677886926);
            r = uint256::rsh(r, PRECISION);
        };

        // check for 2^11
        if (i & 2048 > 0) {
            r = uint256::multiply_underlying(r, 20435687552633177494);
            r = uint256::rsh(r, PRECISION);
        };

        // check for 2^12
        if (i & 4096 > 0) {
            r = uint256::multiply_underlying(r, 22639080592224303007);
            r = uint256::rsh(r, PRECISION);
        };

        // check for 2^13
        if (i & 8192 > 0) {
            r = uint256::multiply_underlying(r, 27784196929998399742);
            r = uint256::rsh(r, PRECISION);
        };

        // check for 2^14
        if (i & 16384 > 0) {
            r = uint256::multiply_underlying(r, 41848122137994986128);
            r = uint256::rsh(r, PRECISION);
        };

        // check for 2^15
        if (i & 32768 > 0) {
            r = uint256::multiply_underlying(r, 94936283578220370716);
            r = uint256::rsh(r, PRECISION);
        };

        // check for 2^16
        if (i & 65536 > 0) {
            r = uint256::multiply_underlying(r, 488590176327622479860);
            r = uint256::rsh(r, PRECISION);
        };

        // check for 2^17
        if (i & 131072 > 0) {
            r = uint256::multiply_underlying(r, 12941056668319229769860);
            r = uint256::rsh(r, PRECISION);
        };

        // check for 2^18
        if (i & 262144 > 0) {
            r = uint256::multiply_underlying(r, 9078618265828848800676189);
            r = uint256::rsh(r, PRECISION);
        };

        uint256::downcast(r)
    }

    /// get sqrt(1.0001)^(-i), where i >= 0
    public fun get_square_price_from_tick_negative(i: u64): u128 {
        assert!(i <= 443636, E_TICK_TOO_BIG);
        let r = uint256::new(0, ONE_X);
        if (i & 1 > 0) {
            r = uint256::multiply_underlying(r, 18445821805675392311);
            r = uint256::rsh(r, PRECISION);
        };
        if (i & 2 > 0) {
            r = uint256::multiply_underlying(r, 18444899583751176498);
            r = uint256::rsh(r, PRECISION);
        };
        if (i & 4 > 0) {
            r = uint256::multiply_underlying(r, 18443055278223354162);
            r = uint256::rsh(r, PRECISION);
        };
        if (i & 8 > 0) {
            r = uint256::multiply_underlying(r, 18439367220385604838);
            r = uint256::rsh(r, PRECISION);
        };
        if (i & 16 > 0) {
            r = uint256::multiply_underlying(r, 18431993317065449817);
            r = uint256::rsh(r, PRECISION);
        };
        if (i & 32 > 0) {
            r = uint256::multiply_underlying(r, 18417254355718160513);
            r = uint256::rsh(r, PRECISION);
        };
        if (i & 64 > 0) {
            r = uint256::multiply_underlying(r, 18387811781193591352);
            r = uint256::rsh(r, PRECISION);
        };
        if (i & 128 > 0) {
            r = uint256::multiply_underlying(r, 18329067761203520168);
            r = uint256::rsh(r, PRECISION);
        };
        if (i & 256 > 0) {
            r = uint256::multiply_underlying(r, 18212142134806087854);
            r = uint256::rsh(r, PRECISION);
        };
        if (i & 512 > 0) {
            r = uint256::multiply_underlying(r, 17980523815641551639);
            r = uint256::rsh(r, PRECISION);
        };
        if (i & 1024 > 0) {
            r = uint256::multiply_underlying(r, 17526086738831147013);
            r = uint256::rsh(r, PRECISION);
        };
        if (i & 2048 > 0) {
            r = uint256::multiply_underlying(r, 16651378430235024244);
            r = uint256::rsh(r, PRECISION);
        };
        if (i & 4096 > 0) {
            r = uint256::multiply_underlying(r, 15030750278693429944);
            r = uint256::rsh(r, PRECISION);
        };
        if (i & 8192 > 0) {
            r = uint256::multiply_underlying(r, 12247334978882834399);
            r = uint256::rsh(r, PRECISION);
        };
        if (i & 16384 > 0) {
            r = uint256::multiply_underlying(r, 8131365268884726200);
            r = uint256::rsh(r, PRECISION);
        };
        if (i & 32768 > 0) {
            r = uint256::multiply_underlying(r, 3584323654723342297);
            r = uint256::rsh(r, PRECISION);
        };
        if (i & 65536 > 0) {
            r = uint256::multiply_underlying(r, 696457651847595233);
            r = uint256::rsh(r, PRECISION);
        };
        if (i & 131072 > 0) {
            r = uint256::multiply_underlying(r, 26294789957452057);
            r = uint256::rsh(r, PRECISION);
        };
        if (i & 262144 > 0) {
            r = uint256::multiply_underlying(r, 37481735321082);
            r = uint256::rsh(r, PRECISION);
        };

        uint256::downcast(r)
    }

    /// get log_2 y where y \in [1,2)
    public fun log_2_y(y: u128): u128 {
        assert!(y >= ONE_X && y < TWO_X, E_Y_OUTSIDE_1_2);
        let z_2: u128 = y;
        let r: u128 = 0;
        let sum_m: u8 = 0;
        let m: u8 = 0;

        loop {
            if (z_2 == ONE_X) {
                break
            };
            let z = uint256::underlying_mul_to_uint256(z_2, z_2);
            z = uint256::rsh(z, PRECISION);
            let z = uint256::downcast(z);
            sum_m = sum_m + 1;
            m = m + 1;
            if (sum_m > PRECISION) {
                break
            };
            if (z >= TWO_X) {
                r = r + (ONE_X >> sum_m);
                z_2 = z >> 1;
            } else {
                z_2 = z;
            };
        };

        r
    }

    public fun log_2(y: u128): Int128 {
        assert!(y != 0, E_ZERO_FOR_LOG_2);
        let leading_zeros = uint256::underlying_leading_zeros(y);
        if (y == ONE_X) {
            int128::zero()
        } else if (y > ONE_X) {
            let n_0: u8 = 128 - PRECISION - leading_zeros - 1;
            let r = (n_0 as u128) << PRECISION;
            int128::new(r + log_2_y(y >> n_0), false)
        } else {
            let n_0: u8 = leading_zeros - (128 - PRECISION - 1);
            let r = (n_0 as u128) << PRECISION;
            let intpart = int128::new(r, true);
            int128::add(int128::new(log_2_y(y << n_0), false), intpart)
        }
    }

    public fun get_tick(sqrt_p: u128): Int64 {
        let log_2_y = log_2(sqrt_p);
        let is_neg = int128::is_negative(log_2_y);
        let log_2_y = int128::abs(log_2_y);
        let ratio = if (is_neg) {
            let r = log_2_y / SQUARE_PRICE_NEG_LOG_2_ABS;
            if (r * SQUARE_PRICE_NEG_LOG_2_ABS < log_2_y) {
                r + 1
            } else {
                r
            }
        } else {
            log_2_y / SQUARE_PRICE_LOG_2        
        };
        int64::new((ratio as u64), is_neg)
    }

    #[test_only]
    public fun get_square_price_from_2_n_positive(i: u8): u128 {
        if (i == 0) {
            18447666387855959850
        } else if (i == 1) {
            18448588748116922571
        } else if (i == 2) {
            18450433606991734263
        } else if (i == 3) {
            18454123878217468680
        } else if (i == 4) {
            18461506635090006701
        } else if (i == 5) {
            18476281010653910144
        } else if (i == 6) {
            18505865242158250041
        } else if (i == 7) {
            18565175891880433522
        } else if (i == 8) {
            18684368066214940582
        } else if (i == 9) {
            18925053041275764671
        } else if (i == 10) {
            19415764168677886926
        } else if (i == 11) {
            20435687552633177494
        } else if (i == 12) {
            22639080592224303007
        } else if (i == 13) {
            27784196929998399742
        } else if (i == 14) {
            41848122137994986128
        } else if (i == 15) {
            94936283578220370716
        } else if (i == 16) {
            488590176327622479860
        } else if (i == 17) {
            12941056668319229769860
        } else if (i == 18) {
            9078618265828848800676189
        } else {
            abort((i as u64))
        }
    }
    #[test_only]
    public fun get_square_price_from_2_n_negative(i: u8): u128 {
        if (i == 0) {
            18445821805675392311
        } else if (i == 1) {
            18444899583751176498
        } else if (i == 2) {
            18443055278223354162
        } else if (i == 3) {
            18439367220385604838
        } else if (i == 4) {
            18431993317065449817
        } else if (i == 5) {
            18417254355718160513
        } else if (i == 6) {
            18387811781193591352
        } else if (i == 7) {
            18329067761203520168
        } else if (i == 8) {
            18212142134806087854
        } else if (i == 9) {
            17980523815641551639
        } else if (i == 10) {
            17526086738831147013
        } else if (i == 11) {
            16651378430235024244
        } else if (i == 12) {
            15030750278693429944
        } else if (i == 13) {
            12247334978882834399
        } else if (i == 14) {
            8131365268884726200
        } else if (i == 15) {
            3584323654723342297
        } else if (i == 16) {
            696457651847595233
        } else if (i == 17) {
            26294789957452057
        } else if (i == 18) {
            37481735321082
        } else {
            abort((i as u64))
        }
    }

    #[test]
    fun test_log_2_y() {
        assert!(int128::is_zero(log_2(ONE_X)), 1);

        // check positive side
        let square_price_0 = 18447666387855959850u128;
        let ratio_0 = get_tick(square_price_0);
        let abs_ratio_0 = int64::abs(ratio_0);
        assert!(abs_ratio_0 == 1, abs_ratio_0);

        // check positive side
        let square_price_1 = 18448588748116922571u128;
        let ratio_1 = get_tick(square_price_1);
        let abs_ratio_1 = int64::abs(ratio_1);
        assert!(abs_ratio_1 == 2, abs_ratio_1);

        // check positive side
        let square_price_2 = 18450433606991734263u128;
        let ratio_2 = get_tick(square_price_2);
        let abs_ratio_2 = int64::abs(ratio_2);
        assert!(abs_ratio_2 == 4, abs_ratio_2);

        // check positive side
        let square_price_3 = 18454123878217468680u128;
        let ratio_3 = get_tick(square_price_3);
        let abs_ratio_3 = int64::abs(ratio_3);
        assert!(abs_ratio_3 == 8, abs_ratio_3);

        // check positive side
        let square_price_4 = 18461506635090006701u128;
        let ratio_4 = get_tick(square_price_4);
        let abs_ratio_4 = int64::abs(ratio_4);
        assert!(abs_ratio_4 == 16, abs_ratio_4);

        // check positive side
        let square_price_5 = 18476281010653910144u128;
        let ratio_5 = get_tick(square_price_5);
        let abs_ratio_5 = int64::abs(ratio_5);
        assert!(abs_ratio_5 == 32, abs_ratio_5);

        // check positive side
        let square_price_6 = 18505865242158250041u128;
        let ratio_6 = get_tick(square_price_6);
        let abs_ratio_6 = int64::abs(ratio_6);
        assert!(abs_ratio_6 == 64, abs_ratio_6);

        // check positive side
        let square_price_7 = 18565175891880433522u128;
        let ratio_7 = get_tick(square_price_7);
        let abs_ratio_7 = int64::abs(ratio_7);
        assert!(abs_ratio_7 == 128, abs_ratio_7);

        // check positive side
        let square_price_8 = 18684368066214940582u128;
        let ratio_8 = get_tick(square_price_8);
        let abs_ratio_8 = int64::abs(ratio_8);
        assert!(abs_ratio_8 == 256, abs_ratio_8);

        // check positive side
        let square_price_9 = 18925053041275764671u128;
        let ratio_9 = get_tick(square_price_9);
        let abs_ratio_9 = int64::abs(ratio_9);
        assert!(abs_ratio_9 == 512, abs_ratio_9);

        // check positive side
        let square_price_10 = 19415764168677886926u128;
        let ratio_10 = get_tick(square_price_10);
        let abs_ratio_10 = int64::abs(ratio_10);
        assert!(abs_ratio_10 == 1024, abs_ratio_10);

        // check positive side
        let square_price_11 = 20435687552633177494u128;
        let ratio_11 = get_tick(square_price_11);
        let abs_ratio_11 = int64::abs(ratio_11);
        assert!(abs_ratio_11 == 2048, abs_ratio_11);

        // check positive side
        let square_price_12 = 22639080592224303007u128;
        let ratio_12 = get_tick(square_price_12);
        let abs_ratio_12 = int64::abs(ratio_12);
        assert!(abs_ratio_12 == 4096, abs_ratio_12);

        // check positive side
        let square_price_13 = 27784196929998399742u128;
        let ratio_13 = get_tick(square_price_13);
        let abs_ratio_13 = int64::abs(ratio_13);
        assert!(abs_ratio_13 == 8192, abs_ratio_13);

        // check positive side
        let square_price_14 = 41848122137994986128u128;
        let ratio_14 = get_tick(square_price_14);
        let abs_ratio_14 = int64::abs(ratio_14);
        assert!(abs_ratio_14 == 16384, abs_ratio_14);

        // check positive side
        let square_price_15 = 94936283578220370716u128;
        let ratio_15 = get_tick(square_price_15);
        let abs_ratio_15 = int64::abs(ratio_15);
        assert!(abs_ratio_15 == 32768, abs_ratio_15);

        // check positive side
        let square_price_16 = 488590176327622479860u128;
        let ratio_16 = get_tick(square_price_16);
        let abs_ratio_16 = int64::abs(ratio_16);
        assert!(abs_ratio_16 == 65536, abs_ratio_16);

        // check positive side
        let square_price_17 = 12941056668319229769860u128;
        let ratio_17 = get_tick(square_price_17);
        let abs_ratio_17 = int64::abs(ratio_17);
        assert!(abs_ratio_17 == 131072, abs_ratio_17);

        // check positive side
        let square_price_18 = 9078618265828848800676189u128;
        let ratio_18 = get_tick(square_price_18);
        let abs_ratio_18 = int64::abs(ratio_18);
        assert!(abs_ratio_18 == 262144, abs_ratio_18);

        // check negative side
        let square_price_0 = 18445821805675392311u128;
        let ratio_0 = get_tick(square_price_0);
        let abs_ratio_0 = int64::abs(ratio_0);
        assert!(abs_ratio_0 == 1, abs_ratio_0);
        // check negative side
        let square_price_1 = 18444899583751176498u128;
        let ratio_1 = get_tick(square_price_1);
        let abs_ratio_1 = int64::abs(ratio_1);
        assert!(abs_ratio_1 == 2, abs_ratio_1);
        // check negative side
        let square_price_2 = 18443055278223354162u128;
        let ratio_2 = get_tick(square_price_2);
        let abs_ratio_2 = int64::abs(ratio_2);
        assert!(abs_ratio_2 == 4, abs_ratio_2);
        // check negative side
        let square_price_3 = 18439367220385604838u128;
        let ratio_3 = get_tick(square_price_3);
        let abs_ratio_3 = int64::abs(ratio_3);
        assert!(abs_ratio_3 == 8, abs_ratio_3);
        // check negative side
        let square_price_4 = 18431993317065449817u128;
        let ratio_4 = get_tick(square_price_4);
        let abs_ratio_4 = int64::abs(ratio_4);
        assert!(abs_ratio_4 == 16, abs_ratio_4);
        // check negative side
        let square_price_5 = 18417254355718160513u128;
        let ratio_5 = get_tick(square_price_5);
        let abs_ratio_5 = int64::abs(ratio_5);
        assert!(abs_ratio_5 == 32, abs_ratio_5);
        // check negative side
        let square_price_6 = 18387811781193591352u128;
        let ratio_6 = get_tick(square_price_6);
        let abs_ratio_6 = int64::abs(ratio_6);
        assert!(abs_ratio_6 == 64, abs_ratio_6);
        // check negative side
        let square_price_7 = 18329067761203520168u128;
        let ratio_7 = get_tick(square_price_7);
        let abs_ratio_7 = int64::abs(ratio_7);
        assert!(abs_ratio_7 == 128, abs_ratio_7);
        // check negative side
        let square_price_8 = 18212142134806087854u128;
        let ratio_8 = get_tick(square_price_8);
        let abs_ratio_8 = int64::abs(ratio_8);
        assert!(abs_ratio_8 == 256, abs_ratio_8);
        // check negative side
        let square_price_9 = 17980523815641551639u128;
        let ratio_9 = get_tick(square_price_9);
        let abs_ratio_9 = int64::abs(ratio_9);
        assert!(abs_ratio_9 == 512, abs_ratio_9);
        // check negative side
        let square_price_10 = 17526086738831147013u128;
        let ratio_10 = get_tick(square_price_10);
        let abs_ratio_10 = int64::abs(ratio_10);
        assert!(abs_ratio_10 == 1024, abs_ratio_10);
        // check negative side
        let square_price_11 = 16651378430235024244u128;
        let ratio_11 = get_tick(square_price_11);
        let abs_ratio_11 = int64::abs(ratio_11);
        assert!(abs_ratio_11 == 2048, abs_ratio_11);
        // check negative side
        let square_price_12 = 15030750278693429944u128;
        let ratio_12 = get_tick(square_price_12);
        let abs_ratio_12 = int64::abs(ratio_12);
        assert!(abs_ratio_12 == 4096, abs_ratio_12);
        // check negative side
        let square_price_13 = 12247334978882834399u128;
        let ratio_13 = get_tick(square_price_13);
        let abs_ratio_13 = int64::abs(ratio_13);
        assert!(abs_ratio_13 == 8192, abs_ratio_13);
        // check negative side
        let square_price_14 = 8131365268884726200u128;
        let ratio_14 = get_tick(square_price_14);
        let abs_ratio_14 = int64::abs(ratio_14);
        assert!(abs_ratio_14 == 16384, abs_ratio_14);
        // check negative side
        let square_price_15 = 3584323654723342297u128;
        let ratio_15 = get_tick(square_price_15);
        let abs_ratio_15 = int64::abs(ratio_15);
        assert!(abs_ratio_15 == 32768, abs_ratio_15);
        // check negative side
        let square_price_16 = 696457651847595233u128;
        let ratio_16 = get_tick(square_price_16);
        let abs_ratio_16 = int64::abs(ratio_16);
        assert!(abs_ratio_16 == 65536, abs_ratio_16);
        // check negative side
        let square_price_17 = 26294789957452057u128;
        let ratio_17 = get_tick(square_price_17);
        let abs_ratio_17 = int64::abs(ratio_17);
        assert!(abs_ratio_17 == 131072, abs_ratio_17);
        // check negative side
        let square_price_18 = 37481735321082u128;
        let ratio_18 = get_tick(square_price_18);
        let abs_ratio_18 = int64::abs(ratio_18);
        assert!(abs_ratio_18 == 262144, abs_ratio_18);
    }
}
