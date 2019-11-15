import { acceptance } from "helpers/qunit-helpers";

acceptance("Team Building: Manage", {
  loggedIn: true,
  pretend(server, helper) {
    server.get("/team-build/targets.json", () => {
      return helper.response(200, {
        teambuild_targets: [
          {
            id: 1,
            target_type_id: 1,
            name: "existing target"
          }
        ]
      });
    });
    server.post("/team-build/targets.json", () => {
      return helper.response(200, { teambuild_target: {} });
    });
    server.delete("/team-build/targets/:id.json", () => {
      return helper.response(200, { success: true });
    });
  }
});

QUnit.test("can cancel creating", async assert => {
  await visit("/team-build/manage");
  await click(".create-target");
  assert.equal(find(".teambuild-target.new").length, 1);
  await click(".teambuild-target.new .cancel");
  assert.equal(find(".teambuild-target.new").length, 0);
});

QUnit.test("can create a new regular target", async assert => {
  await visit("/team-build/manage");
  await click(".create-target");
  assert.equal(find(".teambuild-target.new").length, 1);
  assert.equal(find(".teambuild-target.new .save[disabled]").length, 1);
  await click(".teambuild-target.new .target-types input.regular");
  await fillIn(".teambuild-target.new .target-name input", "Cool target");
  assert.equal(find(".teambuild-target.new .save[disabled]").length, 0);
  await click(".teambuild-target.new .save");
  assert.equal(find(".teambuild-target.new").length, 0);
});

QUnit.test("can delete", async assert => {
  await visit("/team-build/manage");
  assert.equal(find(".teambuild-target").length, 1);
  await click(".teambuild-target:eq(0) .destroy");
  assert.equal(find(".teambuild-target").length, 0);
});
