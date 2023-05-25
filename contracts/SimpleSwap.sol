// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.0;
pragma abicoder v2;

import '@uniswap/v3-periphery/contracts/libraries/TransferHelper.sol';
import '@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol';

interface IWETH {
    function deposit() external payable;

    function withdraw(uint) external;

    function totalSupply() external view returns (uint);

    function balanceOf(address account) external view returns (uint);

}





contract SimpleSwap {
    ISwapRouter public constant swapRouter = ISwapRouter(0xE592427A0AEce92De3Edee1F18E0157C05861564);
    address public constant WETH9 = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    uint24 public constant feeTier = 3000;
    

    receive ()external payable {}

    

    IWETH public WrappedETHcontract;
   
    constructor() payable {       
        //this WETH9 address is for ETH mainnet. Functionality to support multiple EVM networks
        //will come later 
        WrappedETHcontract = IWETH(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);      
    }
    
    function swapWETHForALTcoin(uint amountIn, address ALTcoin) public returns (uint256 amountOut) {

       
        
        // Approve the router to spend WETH9.
        TransferHelper.safeApprove(WETH9, address(swapRouter), amountIn);
        // Create the params that will be used to execute the swap
        ISwapRouter.ExactInputSingleParams memory params =
            ISwapRouter.ExactInputSingleParams({
                tokenIn: WETH9,
                tokenOut: ALTcoin,
                fee: feeTier,
                recipient: address(this),
                deadline: block.timestamp,
                amountIn: amountIn,
                amountOutMinimum: 0,
                sqrtPriceLimitX96: 0
            });
        // The call to `exactInputSingle` executes the swap.
        amountOut = swapRouter.exactInputSingle(params);
        return amountOut; 
    }


     function SwapforWETH (uint amount) public {   
       WrappedETHcontract.deposit{value: amount}();  
    }


    function withdrawWETHforETH (uint amountIN) public {
        WrappedETHcontract.withdraw(amountIN);
    }

    


     function swapALTcoinForWETH(address ALTcoin, uint amountIn) public returns (uint256 amountOut) {

        
        // Approve the router to spend WETH9.
        TransferHelper.safeApprove(ALTcoin, address(swapRouter), amountIn);
        // Create the params that will be used to execute the swap
        ISwapRouter.ExactInputSingleParams memory params =
            ISwapRouter.ExactInputSingleParams({
                tokenIn: ALTcoin,
                tokenOut: WETH9,
                fee: feeTier,
                recipient: address(this),
                deadline: block.timestamp,
                amountIn: amountIn,
                amountOutMinimum: 0,
                sqrtPriceLimitX96: 0
            });
        // The call to `exactInputSingle` executes the swap.
        amountOut = swapRouter.exactInputSingle(params);
        return amountOut; 
    }



}
