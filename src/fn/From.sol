// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Primitive} from "src/primitive/Primitive.sol";
import {Fn} from "src/fn/Fn.sol";

library From {
    function asZeroArgs(Fn self) internal pure returns (function() pure returns (Primitive) f) {
        assembly {
            f := self
        }
    }

    function asOneArg(Fn self) internal pure returns (function(Primitive) pure returns (Primitive) f) {
        assembly {
            f := self
        }
    }

    function asTwoArgs(Fn self) internal pure returns (function(Primitive, Primitive) pure returns (Primitive) f) {
        assembly {
            f := self
        }
    }

    function asThreeArgs(Fn self) internal pure returns (function(Primitive, Primitive, Primitive) pure returns (Primitive) f) {
        assembly {
            f := self
        }
    }

    function asFourArgs(Fn self) internal pure returns (function(Primitive, Primitive, Primitive, Primitive) pure returns (Primitive) f) {
        assembly {
            f := self
        }
    }

    function asFiveArgs(Fn self) internal pure returns (function(Primitive, Primitive, Primitive, Primitive, Primitive) pure returns (Primitive) f) {
        assembly {
            f := self
        }
    }

    function asSixArgs(Fn self) internal pure returns (function(Primitive, Primitive, Primitive, Primitive, Primitive, Primitive) pure returns (Primitive) f) {
        assembly {
            f := self
        }
    }

    function asSevenArgs(Fn self) internal pure returns (function(Primitive, Primitive, Primitive, Primitive, Primitive, Primitive, Primitive) pure returns (Primitive) f) {
        assembly {
            f := self
        }
    }

    function asEightArgs(Fn self) internal pure returns (function(Primitive, Primitive, Primitive, Primitive, Primitive, Primitive, Primitive, Primitive) pure returns (Primitive) f) {
        assembly {
            f := self
        }
    }
}
