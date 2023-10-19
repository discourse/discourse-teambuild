import {
  acceptance,
  count,
  query,
} from "discourse/tests/helpers/qunit-helpers";
import { click, fillIn, visit } from "@ember/test-helpers";
import { test } from "qunit";

acceptance("Team Building: Manage", function (needs) {
  needs.user({ can_access_teambuild: true });
  needs.pretender((server, helper) => {
    server.get("/team-build/targets.json", () => {
      return helper.response(200, {
        teambuild_targets: [
          {
            id: 1,
            target_type_id: 1,
            name: "existing target",
          },
        ],
        extras: {
          groups: [{ id: 1, name: "cool group" }],
        },
      });
    });
    server.put("/team-build/targets/:id.json", (request) => {
      let data = JSON.parse(request.requestBody);
      return helper.response(200, data);
    });
    server.post("/team-build/targets.json", () => {
      return helper.response(200, { teambuild_target: {} });
    });
    server.delete("/team-build/targets/:id.json", () => {
      return helper.response(200, { success: true });
    });
  });

  test("can cancel creating", async function (assert) {
    await visit("/team-build/manage");
    await click(".create-target");
    assert.strictEqual(count(".teambuild-target.editing"), 1);
    await click(".teambuild-target.editing .cancel");
    assert.strictEqual(count(".teambuild-target.editing"), 0);
  });

  test("can create a new regular target", async function (assert) {
    await visit("/team-build/manage");
    await click(".create-target");
    assert.strictEqual(count(".teambuild-target.editing"), 1);
    assert.strictEqual(count(".teambuild-target.editing .save[disabled]"), 1);
    await click(".teambuild-target.editing .target-types input.regular");
    await fillIn(".teambuild-target.editing .target-name input", "Cool target");
    assert.strictEqual(count(".teambuild-target.editing .save[disabled]"), 0);
    await click(".teambuild-target.editing .save");
    assert.strictEqual(count(".teambuild-target.editing"), 0);
  });

  test("can delete", async function (assert) {
    await visit("/team-build/manage");
    assert.strictEqual(count(".teambuild-target"), 1);
    await click(".teambuild-target .destroy");
    assert.strictEqual(count(".teambuild-target"), 0);
  });

  test("can cancel edit", async function (assert) {
    await visit("/team-build/manage");
    await click(".teambuild-target .edit");
    await fillIn(".teambuild-target.editing .target-name input", "New Name");
    await click(".teambuild-target.editing .cancel");
    assert.strictEqual(
      query(".teambuild-target .target-name").innerText.trim(),
      "existing target"
    );
    await click(".teambuild-target .edit");
    assert.strictEqual(
      query(".teambuild-target.editing .target-name input").value,
      "existing target"
    );
  });

  test("can update", async function (assert) {
    await visit("/team-build/manage");
    await click(".teambuild-target .edit");
    await fillIn(".teambuild-target.editing .target-name input", "New Name");
    await click(".teambuild-target.editing .save");
    assert.strictEqual(
      query(".teambuild-target .target-name").innerText.trim(),
      "New Name"
    );
  });

  test("has links in sidebar", async (assert) => {
    await visit("/team-build/manage");

    await click(".sidebar-more-section-links-details-summary");

    assert
      .dom(".sidebar-section-link[data-link-name='team-building']")
      .hasText("Team Building");
  });
});
