// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

import "./BasicFYToken.sol";

/// @dev The PoolFactory can deterministically create new pool instances.
contract BasicFYTokenFactory {
  event TokenCreated(address indexed underlying, address token);

  address[] public tokens;

  /// @dev Deploys a new fixed yield token.
  /// @param underlying Address of the ERC20 token for sale & redemption.
  /// @param maturity Timestamp of the maturity date of the bond.
  /// @param name Name of the fyToken.
  /// @param symbol Symbol of the fyToken.
  /// @return token The token address.
  function createToken(
    address underlying,
    uint256 maturity,
    string calldata name,
    string calldata symbol
  ) external returns (address token) {
    token = address(new BasicFYToken(underlying, maturity, name, symbol));
    BasicFYToken(token).transferOwnership(msg.sender);

    emit TokenCreated(underlying, token);
  }
}
