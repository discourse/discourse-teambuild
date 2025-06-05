import RouteTemplate from "ember-route-template";
import replaceEmoji from "discourse/helpers/replace-emoji";
import { i18n } from "discourse-i18n";
import TeambuildChoice from "../components/teambuild-choice";

export default RouteTemplate(
  <template>
    {{#if @controller.siteSettings.teambuild_description}}
      <div class="teambuild-description">
        {{@controller.siteSettings.teambuild_description}}
      </div>
    {{/if}}

    <div class="completed-score">
      <div class="username">@{{@controller.progress.user.username}}</div>
      <div class="status">
        {{i18n "discourse_teambuild.progress.completed"}}:
        {{@controller.progress.completed.length}}
        /
        {{@controller.progress.total}}
      </div>
    </div>

    <div class="all-targets">
      {{#each @controller.progress.teambuild_targets as |target|}}
        <div class="target-type">
          {{#if target.group_id}}
            <div class="description">{{replaceEmoji target.name}}</div>
            <div class="target-choices multi-choice">
              {{#each target.users as |u|}}
                <TeambuildChoice
                  @label={{u.username}}
                  @progress={{@controller.progress}}
                  @target={{target}}
                  @userId={{u.id}}
                  @readOnly={{@controller.readOnly}}
                />
              {{/each}}
            </div>
          {{else}}
            <TeambuildChoice
              @label={{replaceEmoji target.name}}
              @progress={{@controller.progress}}
              @target={{target}}
              @userId={{@controller.progress.user.id}}
              @readOnly={{@controller.readOnly}}
            />
          {{/if}}
        </div>
      {{else}}
        <p>{{i18n "discourse_teambuild.progress.none"}}</p>
      {{/each}}
    </div>
  </template>
);
