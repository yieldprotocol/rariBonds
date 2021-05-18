// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

import "../interfaces/IFYToken.sol";

interface IBasicFYToken is IFYToken {
  event SetMinter(address minter);

  function setMinter(address _newMinter) external;
}
