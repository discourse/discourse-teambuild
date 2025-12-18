import { click, fillIn, visit } from "@ember/test-helpers";
import { test } from "qunit";
import { acceptance } from "discourse/tests/helpers/qunit-helpers";

acceptance("Team Building: Manage", function (needs) {
  needs.user({ can_access_teambuild: true });
  needs.pretender((server, helper) => {
    server.get("/team-build/scores.json", () => {
      return helper.response(200, {
        scores: [
          {
            id: 1,
            username: "user1",
            username_lower: "user1",
            score: 10,
            rank: 1,
            trophy: true,
            me: false,
            avatar_template:
              "/letter_avatar_proxy/v4/letter/u/3be4f8/{size}.png",
          },
          {
            id: 2,
            username: "user2",
            username_lower: "user2",
            score: 5,
            rank: 2,
            trophy: false,
            me: true,
            avatar_template:
              "/letter_avatar_proxy/v4/letter/u/3be4f8/{size}.png",
          },
        ],
      });
    });
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
    assert.dom(".teambuild-target.editing").exists();

    await click(".teambuild-target.editing .cancel");
    assert.dom(".teambuild-target.editing").doesNotExist();
  });

  test("can create a new regular target", async function (assert) {
    await visit("/team-build/manage");
    await click(".create-target");
    assert.dom(".teambuild-target.editing").exists();
    assert.dom(".teambuild-target.editing .save").isDisabled();

    await click(".teambuild-target.editing .target-types input.regular");
    await fillIn(".teambuild-target.editing .target-name input", "Cool target");
    assert.dom(".teambuild-target.editing .save").isNotDisabled();

    await click(".teambuild-target.editing .save");
    assert.dom(".teambuild-target.editing").doesNotExist();
  });

  test("can delete", async function (assert) {
    await visit("/team-build/manage");
    assert.dom(".teambuild-target").exists();

    await click(".teambuild-target .destroy");
    assert.dom(".teambuild-target").doesNotExist();
  });

  test("can cancel edit", async function (assert) {
    await visit("/team-build/manage");
    await click(".teambuild-target .edit");
    await fillIn(".teambuild-target.editing .target-name input", "New Name");
    await click(".teambuild-target.editing .cancel");
    assert.dom(".teambuild-target .target-name").hasText("existing target");

    await click(".teambuild-target .edit");
    assert
      .dom(".teambuild-target.editing .target-name input")
      .hasValue("existing target");
  });

  test("can update", async function (assert) {
    await visit("/team-build/manage");
    await click(".teambuild-target .edit");
    await fillIn(".teambuild-target.editing .target-name input", "New Name");
    await click(".teambuild-target.editing .save");
    assert.dom(".teambuild-target .target-name").hasText("New Name");
  });

  test("has links in sidebar", async (assert) => {
    await visit("/team-build/manage");
    await click(".sidebar-more-section-links-details-summary");

    assert
      .dom(".sidebar-section-link[data-link-name='team-building']")
      .hasText("Team Building");
  });
});
