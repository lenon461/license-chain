/*
 * SPDX-License-Identifier: Apache-2.0
 */

'use strict';

const { Contract } = require('fabric-contract-api');

class License extends Contract {

    async initLedger(ctx) {
        console.info('============= START : Initialize Ledger ===========');
        const issue = [
            {
                IssueDate : new Date(),
                IssuingOffice : "Office1",
                IssuingManager : "Manager1",
                Name : "Lenon",
                RRNumber : "951209-1112222",
                Conditions : "A",
            },
        ];

        await ctx.stub.putState('LIC' + 0, Buffer.from(JSON.stringify(issue[0])));
        console.info('Added <--> ', issue[0]);
        console.info('============= END : Initialize Ledger ===========');
    }

    async findIssue(ctx, mykey) {
        const issueAsBytes = await ctx.stub.getState("LIC" + mykey); // get the car from chaincode state
        if (!issueAsBytes || issueAsBytes.length === 0) {
            throw new Error(`${mykey} does not exist`);
        }
        console.log(issueAsBytes.toString());
        return issueAsBytes.toString();
    }

    async addIssue(ctx, IssuingOffice, IssuingManager, Name, RRNumber, Conditions){
        console.info('============= START : Create License ===========');

        var issueNum = 0;
        var issueAsBytes = await ctx.stub.getState("LIC" + issueNum); // get the car from chaincode state
        while (issueAsBytes && issueAsBytes.length !== 0) {
            issueNum++;
            issueAsBytes = await ctx.stub.getState("LIC" + issueNum); // get the car from chaincode state
        }
        const issue = [
            {
                IssueDate : new Date(),
                IssuingOffice : IssuingOffice,
                IssuingManager : IssuingManager,
                Name : Name,
                RRNumber : RRNumber,
                Conditions : Conditions,
            },
        ];

        await ctx.stub.putState('LIC' + issueNum, Buffer.from(JSON.stringify(issue)));
        console.info('============= END : Create License ===========');
    }

    async AllIssue(ctx) {
        const startKey = 'LIC0';
        const endKey = 'LIC999';
        const iterator = await ctx.stub.getStateByRange(startKey, endKey);

        const allResults = [];
        while (true) {
            const res = await iterator.next();

            if (res.value && res.value.value.toString()) {
                console.log(res.value.value.toString('utf8'));

                const Key = res.value.key;
                let Record;
                try {
                    Record = JSON.parse(res.value.value.toString('utf8'));
                } catch (err) {
                    console.log(err);
                    Record = res.value.value.toString('utf8');
                }
                allResults.push({ Key, Record });
            }
            if (res.done) {
                console.log('end of data');
                await iterator.close();
                console.info(allResults);
                return JSON.stringify(allResults);
            }
        }
    }
}

module.exports = License;
