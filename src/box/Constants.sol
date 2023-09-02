// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Primitive} from "src/primitive/Primitive.sol";

library Constants {
    Primitive internal constant FULL_MASK = Primitive.wrap(0xffffffffffffffff);
    Primitive internal constant PTR_MASK = Primitive.wrap(0xffffffff);
    Primitive internal constant LEN_MASK = Primitive.wrap(0xffffffff);

    Primitive internal constant PTR_OFFSET = Primitive.wrap(32);
}
