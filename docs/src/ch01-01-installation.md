# Installation

The library is written in Foundry, so we can download the library as any other.

By repository owner and package name:

```bash
forge install jtriley-eth/smart-types
```

By Github URL:

```bash
forge install https://github.com/jtriley-eth/smart-types
```

## Importing

Importing the newly installed dependency can be done in one of the following ways.

No remappings, absolute path from project root:

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import "lib/smart-types/src/Prelude.sol";
```

Remapping (VSCode may require `remappings.txt` file as well):

```toml
# foundry.toml
[profile.default]
src = "src"
out = "out"
libs = ["lib"]

remappings = ["@smart-types/=lib/smart-types/src/"]
```

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import "@smart-types/Prelude.sol";
```
