const main = async () => {
  const gmContractFactory = await hre.ethers.getContractFactory("GmPortal");
  const gmContract = await gmContractFactory.deploy({
    value: hre.ethers.utils.parseEther("0.1"),
  });
  await gmContract.deployed();

  console.log("Contract deployed to:", gmContract.address);

  let contractBalance = await hre.ethers.provider.getBalance(
    gmContract.address
  );

  console.log(
    "Contract balance:",
    hre.ethers.utils.formatEther(contractBalance)
  );

  let gmTxn = await gmContract.gm("This is gm 1");
  await gmTxn.wait();

  await sleep(7 * 1000);

  gmTxn = await gmContract.gm("This is gm 2");
  await gmTxn.wait();

  await sleep(7 * 1000);

  gmTxn = await gmContract.gm("This is gm 3");
  await gmTxn.wait();

  contractBalance = await hre.ethers.provider.getBalance(gmContract.address);
  console.log(
    "Contract balance:",
    hre.ethers.utils.formatEther(contractBalance)
  );

  let allGms = await gmContract.getAllGms();
  console.log(allGms);
};

function sleep(ms) {
  return new Promise((resolve) => {
    setTimeout(resolve, ms);
  });
}

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

runMain();
