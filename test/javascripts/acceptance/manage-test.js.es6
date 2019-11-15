import { acceptance } from "helpers/qunit-helpers";

acceptance("Team Building: Manage", {
  loggedIn: true,
  pretend(server, helper) {
    server.get("/team-build/targets.json", () => {
      return helper.response(200, {
        teambuild_targets: []
      });
    });
  }
});

QUnit.test("can create a new regular target", async assert => {
  await visit("/team-build/manage");
  await click(".create-target");
  assert.equal(find(".teambuild-target.new").length, 1);
  await click(".teambuild-target.new .target-types input.regular");
  await fillIn(".teambuild-target.new .target-name input", "Cool target");
  await click(".teambuild-target.new .save");
});
