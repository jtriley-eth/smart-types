// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Primitive} from "src/primitive/Primitive.sol";

library Constants {
    Primitive internal constant ZERO = Primitive.wrap(0);
    Primitive internal constant ONE = Primitive.wrap(1);
    Primitive internal constant TWO = Primitive.wrap(2);
    Primitive internal constant THREE = Primitive.wrap(3);
    Primitive internal constant FOUR = Primitive.wrap(4);
    Primitive internal constant FIVE = Primitive.wrap(5);
    Primitive internal constant SIX = Primitive.wrap(6);
    Primitive internal constant SEVEN = Primitive.wrap(7);
    Primitive internal constant EIGHT = Primitive.wrap(8);
    Primitive internal constant ARG_SIZE = Primitive.wrap(32);

    Primitive internal constant DEST_OFFSET = Primitive.wrap(56);
    Primitive internal constant KIND_OFFSET = Primitive.wrap(48);
    Primitive internal constant APPLIED_OFFSET = Primitive.wrap(40);
    Primitive internal constant EXPECTED_OFFSET = Primitive.wrap(32);
    Primitive internal constant ARG_KIND_OFFSET = Primitive.wrap(72);

    Primitive internal constant DEST_MASK = Primitive.wrap(0xffff);
    Primitive internal constant KIND_MASK = Primitive.wrap(0xff);
    Primitive internal constant APPLIED_MASK = Primitive.wrap(0xff);
    Primitive internal constant EXPECTED_MASK = Primitive.wrap(0xff);
    Primitive internal constant ARG_PTR_MASK = Primitive.wrap(0xffffffff);
    Primitive internal constant KIND_AND_APPLIED_MASK = Primitive.wrap(0xffff);
    Primitive internal constant ARG_KIND_MASK = Primitive.wrap(0x01);
    Primitive internal constant ARG_INNER_MASK = Primitive.wrap(0xffffffffffffffffff);
}
