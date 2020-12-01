pragma solidity 0.4.24;

import { MarginCommon } from "./MarginCommon.sol";

library MarginState {
    struct State {
        // Address of the Vault contract
        address VAULT;
        // Mapping from positionId -> Position, which stores all the open margin positions.
        mapping (bytes32 => MarginCommon.Position) positions;