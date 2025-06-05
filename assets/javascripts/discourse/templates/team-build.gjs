import RouteTemplate from "ember-route-template";
import NavItem from "discourse/components/nav-item";

export default RouteTemplate(
  <template>
    <div class="team-build">
      <h1>{{@controller.siteSettings.teambuild_name}}</h1>

      <ul class="nav nav-pills">
        <NavItem
          @route="teamBuild.index"
          @label="discourse_teambuild.scores.title"
        />
        <NavItem
          @route="teamBuild.progress"
          @label="discourse_teambuild.progress.title"
        />
        {{#if @controller.currentUser.staff}}
          <NavItem
            @route="teamBuild.manage"
            @label="discourse_teambuild.manage.title"
            @icon="wrench"
          />
        {{/if}}
      </ul>

      {{outlet}}
    </div>
  </template>
);
