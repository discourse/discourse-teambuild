import { fn } from "@ember/helper";
import RouteTemplate from "ember-route-template";
import DButton from "discourse/components/d-button";
import { i18n } from "discourse-i18n";
import TeambuildTarget from "../components/teambuild-target";

export default RouteTemplate(
  <template>
    <div class="teambuild-manage">
      {{#if @controller.targets}}
        {{#each @controller.sortedTargets as |target idx|}}
          <TeambuildTarget
            @target={{target}}
            @groups={{@controller.groups}}
            @index={{idx}}
            @length={{@controller.sortedTargets.length}}
            @removeTarget={{fn this.removeTarget target}}
            @moveUp={{fn this.move idx -1}}
            @moveDown={{fn this.move idx 1}}
          />
        {{/each}}
      {{else}}
        <div class="get-started">
          {{i18n "discourse_teambuild.manage.get_started"}}
        </div>
      {{/if}}

      <div class="controls">
        <DButton
          class="btn-primary create-target"
          @label="discourse_teambuild.targets.create"
          @icon="plus"
          @action={{@controller.newTarget}}
        />
      </div>
    </div>
  </template>
);
