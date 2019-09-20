function goalComplete([goal, completed]) {
  return completed.includes(goal.id);
}

export default Ember.Helper.helper(goalComplete);
