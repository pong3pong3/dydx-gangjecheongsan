pragma solidity 0.4.24;

interface GeneralERC20 {
    function transfer(
        address to,
        uint256 value
    )
        external;
}

library TokenInteract {
    function transfer(
        address token,
        address to,
        uint256 amount
    )
        internal
    {
        address from = address(this);

        GeneralERC20(token).transfer(to, amount);

        require(
            checkSuccess(),
            "TokenInteract#transfer: Transfer failed"
        );
    }