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
    server.put("/team-build/targets/:id.json", request => {
      let data = JSON.parse(request.requestBody);
      return helper.response(200, data);
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
  assert.equal(find(".teambuild-target.editing").length, 1);
  await click(".teambuild-target.editing .cancel");
  assert.equal(find(".teambuild-target.editing").length, 0);
});

QUnit.test("can create a new regular target", async assert => {
  await visit("/team-build/manage");
  await click(".create-target");
  assert.equal(find(".teambuild-target.editing").length, 1);
  assert.equal(find(".teambuild-target.editing .save[disabled]").length, 1);
  await click(".teambuild-target.editing .target-types input.regular");
  await fillIn(".teambuild-target.editing .target-name input", "Cool target");
  assert.equal(find(".teambuild-target.editing .save[disabled]").length, 0);
  await click(".teambuild-target.editing .save");
  assert.equal(find(".teambuild-target.editing").length, 0);
});

QUnit.test("can delete", async assert => {
  await visit("/team-build/manage");
  assert.equal(find(".teambuild-target").length, 1);
  await click(".teambuild-target:eq(0) .destroy");
  assert.equal(find(".teambuild-target").length, 0);
});

QUnit.test("can cancel edit", async assert => {
  await visit("/team-build/manage");
  await click(".teambuild-target:eq(0) .edit");
  await fillIn(".teambuild-target.editing .target-name input", "New Name");
  await click(".teambuild-target.editing .cancel");
  assert.equal(
    find(".teambuild-target:eq(0) .target-name")
      .text()
      .trim(),
    "existing target"
  );
});
QUnit.test("can update", async assert => {
  await visit("/team-build/manage");
  await click(".teambuild-target:eq(0) .edit");
  await fillIn(".teambuild-target.editing .target-name input", "New Name");
  await click(".teambuild-target.editing .save");
  assert.equal(
    find(".teambuild-target:eq(0) .target-name")
      .text()
      .trim(),
    "New Name"
  );
});
