export default function() {
  this.route("teamBuild", { path: "/team-build" }, function() {
    this.route("index", { path: "/" });
    this.route("about", { path: "/about" });
    this.route("goals", { path: "/goals" });
    this.route("show", { path: "/goals/:username" });
  });
}
