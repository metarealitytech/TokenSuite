import { ethers } from "hardhat";
import { expect } from "chai";

describe("Gravitons Token", () => {
  let token: any;
  let owner: any;
  let user: any;

  beforeEach(async () => {
    [owner, user] = await ethers.getSigners();
    const Token = await ethers.getContractFactory("Gravitons");
    token = await Token.deploy();
    await token.deployed();
  });

  it("should have correct name and symbol", async () => {
    expect(await token.name()).to.equal("Gravitons");
    expect(await token.symbol()).to.equal("GRAVI");
    expect(await token.decimals()).to.equal(18);
  });

  it("should assign total supply to deployer", async () => {
    const supply = await token.totalSupply();
    const balance = await token.balanceOf(owner.address);
    expect(balance.toString()).to.equal(supply.toString());
  });

  it("should allow transfers", async () => {
    await token.transfer(user.address, 1000);
    const balance = await token.balanceOf(user.address);
    expect(balance.toString()).to.equal("1000");
  });

  it("should support burning tokens", async () => {
    const initialSupply = await token.totalSupply();
    await token.burn(5000);
    const newSupply = await token.totalSupply();
    expect(newSupply.toString()).to.equal(initialSupply.sub(5000).toString());
  });
});
