import Component, { Input } from "@ember/component";
import { concat, fn } from "@ember/helper";
import { action, computed } from "@ember/object";
import { equal, or } from "@ember/object/computed";
import { underscore } from "@ember/string";
import { tagName } from "@ember-decorators/component";
import BufferedProxy from "ember-buffered-proxy/proxy";
import DButton from "discourse/components/d-button";
import RadioButton from "discourse/components/radio-button";
import replaceEmoji from "discourse/helpers/replace-emoji";
import { popupAjaxError } from "discourse/lib/ajax-error";
import { i18n } from "discourse-i18n";
import ComboBox from "select-kit/components/combo-box";
import { Types } from "discourse/plugins/discourse-teambuild/discourse/models/teambuild-target";

@tagName("")
export default class TeambuildTarget extends Component {
  editSelected = false;

  @equal("buffered.target_type_id", Types.USER_GROUP) needsGroup;
  @or("editSelected", "target.isNew") editing;

  @computed("target")
  get buffered() {
    return BufferedProxy.create({
      content: this.get("target"),
    });
  }

  @computed("editing", "index")
  get canMoveUp() {
    return !this.editing && this.index > 0;
  }

  @computed("editing", "index", "length")
  get canMoveDown() {
    return !this.editing && this.index < this.length - 1;
  }

  get targetTypes() {
    return Object.keys(Types).map((key) => {
      return { id: Types[key], name: underscore(key) };
    });
  }

  @computed(
    "buffered.name",
    "target.isSaving",
    "needsGroup",
    "buffered.group_id"
  )
  get saveDisabled() {
    if (this.target.isSaving) {
      return true;
    }

    let name = this.get("buffered.name");
    if (!name || name.length === 0) {
      return true;
    }

    if (this.needsGroup && !this.get("buffered.group_id")) {
      return true;
    }

    return false;
  }

  @action
  save() {
    this.target
      .save(this.buffered.getProperties("name", "target_type_id", "group_id"))
      .then(() => {
        this.set("editSelected", false);
      })
      .catch(popupAjaxError);
  }

  @action
  cancel() {
    if (this.target.isNew) {
      return this.removeTarget();
    } else {
      this.set("editSelected", false);
      this.buffered.discardChanges();
    }
  }

  @action
  destroyTarget() {
    this.target.destroyRecord().then(() => this.removeTarget());
  }

  <template>
    <div class="teambuild-target {{if this.editing 'editing'}}">
      <div class="target-details">
        {{#if this.editing}}
          <div class="fields">
            <div class="target-types">
              {{#each this.targetTypes as |type|}}
                <label>
                  <RadioButton
                    @value={{type.id}}
                    @selection={{this.buffered.target_type_id}}
                    @onChange={{fn (mut this.buffered.target_type_id) type.id}}
                    class={{type.name}}
                  />
                  {{i18n
                    (concat "discourse_teambuild.targets.types." type.name)
                  }}
                </label>
              {{/each}}
            </div>

            <div class="target-name">
              <Input
                @value={{this.buffered.name}}
                placeholder={{i18n "discourse_teambuild.targets.name"}}
                autofocus="true"
              />
            </div>

            {{#if this.needsGroup}}
              <ComboBox
                @content={{this.groups}}
                @value={{this.buffered.group_id}}
                @none="discourse_teambuild.targets.choose_group"
              />
            {{/if}}
          </div>
        {{else}}
          <div class="target-name">
            {{replaceEmoji this.target.name}}
          </div>
          <div class="target-group-name">
            {{this.target.group_name}}
          </div>
        {{/if}}
      </div>
      <div class="controls">
        {{#if this.canMoveUp}}
          <DButton @icon="arrow-up" @action={{this.moveUp}} />
        {{/if}}

        {{#if this.canMoveDown}}
          <DButton @icon="arrow-down" @action={{this.moveDown}} />
        {{/if}}

        {{#if this.editing}}
          <DButton
            @icon="check"
            @title="discourse_teambuild.targets.save"
            @action={{this.save}}
            @disabled={{this.saveDisabled}}
            class="btn-primary save"
          />

          <DButton
            @icon="xmark"
            @action={{this.cancel}}
            @title="discourse_teambuild.targets.cancel"
            class="btn-danger cancel"
          />
        {{else}}
          <DButton
            @icon="pencil"
            @title="discourse_teambuild.targets.edit"
            @action={{fn (mut this.editSelected) true}}
            class="edit"
          />

          <DButton
            @icon="trash-can"
            @title="discourse_teambuild.targets.delete"
            @action={{this.destroyTarget}}
            class="btn-danger destroy"
          />
        {{/if}}
      </div>
    </div>
  </template>
}
