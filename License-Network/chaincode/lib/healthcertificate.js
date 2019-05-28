'use strict';

const { Contract } = require('fabric-contract-api');
require('data-utils');

Date.prototype.yyyymmdd = function(update){
  let yyyy = parseInt(this.getFullYear()) + update;
  let mm = this.getMonth() + 1; // getMonth() is zero-based
  let dd = this.getDate();
  return [yyyy,
          (mm>9 ? '' : '0') + mm,
          (dd>9 ? '' : '0') + dd
         ].join('');
};

var nextkey = 10001000;
const CreateIssue = (IssuingOffice, IssuingManager, Name, RRNumber, Conditions) => {
    let issue = {};
    issue.IssueDate = new Date().yyyymmdd(0);
    issue.UpdateDate = new Date().yyyymmdd(10);
    issue.IssuingOffice = IssuingOffice;
    issue.IssuingManager = IssuingManager;
    issue.Name = Name;
    issue.RRNumber = RRNumber;
    issue.Conditions = Conditions;
    return issue;
}

class HealthCertificate extends Contract {
    
    async initLedger(ctx){
        console.info('============= START : Initialize Ledger ===========');

        const issue = CreateIssue("Office1", "Manager3", "TEST", "951209-1112222", "A");
        await ctx.stub.putState('LIC' + nextkey, Buffer.from(JSON.stringify(issue)));
        nextkey++;
        Ledger.push(issue);
        console.info('Added <--> ', issue);

        const issue2 = CreateIssue( "Office1", "Manager4", "TEST2", "951209-1113333", "A");
        await ctx.stub.putState('LIC' + nextkey, Buffer.from(JSON.stringify(issue)));
        nextkey++;
        Ledger.push(issue2);
        console.info('Added <--> ', issue2);

        console.info('============= END : Initialize Ledger ===========');
    }

    async addIssue(ctx, IssuingOffice, IssuingManager, Name, RRNumber, Conditions){
        console.info('============= START : addIssue ===========');

        
        const issue = CreateIssue(IssuingOffice, IssuingManager, Name, RRNumber, Conditions);
        await ctx.stub.putState('LIC' + nextkey, Buffer.from(JSON.stringify(issue)));
        nextkey++;
        
        console.info('Added <--> ', issue);
        console.info('============= END : addIssue =============');

    }

    async findIssue(ctx, mykey){
        console.info('============= START : findIssue ===========');

        const issue = await ctx.stub.getState("LIC" + mykey)
        if( !issue || issue.length === 0){
            throw new Error(`${mykey} License does not exist`);
        }
        
        console.info('find <--> ', issue.toString());
        console.info('============= END : findIssue =============');
        return issue.toString();
    }

    async AllIssue(ctx){
        console.info('============= START : AllIssue ===========');

        const startkey = 'LIC10001000';
        const endkey = 'LIC10001999';
        const iterator = await ctx.stub.getStateByRange(startkey, endkey);

        const allResults = [];
        while(true){
            const res = await iterator.next();

            if(res.value && res.value.value.toString()){
                console.log(res.value.value.toString('utf8'));

                const Key = res.value.key;
                let Record;
                try {

                } catch(err) {
                    console.log(err);
                    Record = res.value.value.toString('utf8');
                }
                allResults.push({ Key, Record });
            }
            if (res.done) {
                await iterator.close();
                console.info(allResults);
                return JSON.stringify(allResults);
            }
        }
        console.info('============= END : AllIssue =============');
    }
}
module.exports = HealthCertificate;
