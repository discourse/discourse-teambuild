export default function () {
  this.route("teamBuild", { path: "/team-build" }, function () {
    this.route("index", { path: "/" });
    this.route("progress", { path: "/progress" });
    this.route("manage", { path: "/manage" });
    this.route("show", { path: "/progress/:username" });
  });
}
