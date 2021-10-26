const main = async () => {
  const [owner, randomPerson] = await hre.ethers.getSigners();
  const waveContractFactory = await hre.ethers.getContractFactory("GmPortal");
  const waveContract = await waveContractFactory.deploy();
  await waveContract.deployed();

  console.log("Contract deployed to:", waveContract.address);
  console.log("Contract deployed by:", owner.address);

  let waveCount;
  waveCount = await waveContract.getTotalGms();

  let waveTxn = await waveContract.gm();
  await waveTxn.wait();

  waveCount = await waveContract.getTotalGms();

  waveTxn = await waveContract.connect(randomPerson).gm();
  await waveTxn.wait();

  waveCount = await waveContract.getTotalGms();
};

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
