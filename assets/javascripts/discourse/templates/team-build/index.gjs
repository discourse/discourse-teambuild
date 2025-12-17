import { LinkTo } from "@ember/routing";
import RouteTemplate from "ember-route-template";
import avatar from "discourse/helpers/avatar";
import replaceEmoji from "discourse/helpers/replace-emoji";
import { i18n } from "discourse-i18n";

export default RouteTemplate(
  <template>
    {{#if @controller.scores}}
      <table class="high-scores">
        <thead>
          <tr>
            <th>{{i18n "discourse_teambuild.scores.rank"}}</th>
            <th>{{i18n "discourse_teambuild.scores.user"}}</th>
            <th class="score">{{i18n "discourse_teambuild.scores.score"}}</th>
          </tr>
        </thead>
        <tbody>
          {{#each @controller.scores as |s|}}
            <tr class={{if s.me "me"}}>
              <td class="rank">
                {{s.rank}}
                {{#if s.trophy}}
                  {{replaceEmoji ":trophy:"}}
                {{/if}}
              </td>
              <td class="user">
                {{#if s.me}}
                  <LinkTo @route="teamBuild.progress">
                    {{avatar s imageSize="medium"}}
                    {{s.username}}
                  </LinkTo>
                {{else}}
                  <LinkTo @route="teamBuild.show" @model={{s.username_lower}}>
                    {{avatar s imageSize="medium"}}
                    {{s.username}}
                  </LinkTo>
                {{/if}}
              </td>
              <td class="score">{{s.score}}</td>
            </tr>
          {{/each}}
        </tbody>
      </table>
    {{else}}
      <p>{{i18n "discourse_teambuild.scores.none"}}</p>
    {{/if}}
  </template>
);
