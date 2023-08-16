// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Primitive} from "src/primitive/Primitive.sol";

library Constants {
    Primitive internal constant ENUM_MASK = Primitive.wrap(0x01);
    Primitive internal constant SMART_POINTER_MASK = Primitive.wrap(0xffffffffffffffff);

    Primitive internal constant ENUM_OFFSET = Primitive.wrap(64);
}
