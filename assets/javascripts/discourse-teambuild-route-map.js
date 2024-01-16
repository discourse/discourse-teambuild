export default function () {
  this.route("teamBuild", { path: "/team-build" }, function () {
    this.route("index", { path: "/" });
    this.route("progress");
    this.route("manage");
    this.route("show", { path: "/progress/:username" });
  });
}
