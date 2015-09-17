var Dembele = React.createClass({

  getInitialState: function() {
    return {
      matches:[]
    };
  },

  componentDidMount: function() {
    $.get('/matches', function(matches){
      this.setState({matches: matches});
    }.bind(this));
  },

  render: function() {

    var matches = this.state.matches.map(function(match){
      return <Match match={match} />
    });

    return (
      {matches}
    );
  }

});

React.render(<Dembele />, document.getElementById('app'));



var Match = React.createClass({

  render: function() {

    var match = this.props.match;

    return (
      <div class="card">
        <div class="card-image waves-effect waves-block waves-light">
        </div>
        <div class="card-content">
          <span class="card-title activator grey-text text-darken-4">
          {match.name_of_the_leftside_team} {match.leftside_goals} - {this.props.team_two.name} {this.props.team_two.score}
          <i class="material-icons right">Match Stats</i></span>
        </div>
        <div class="card-reveal">
          <span class="card-title grey-text text-darken-4">Match Stats<i class="material-icons right">Hide</i></span>
          <p>Here are the stats</p>
        </div>
      </div>
    );
  }

});


// <div class="card">
//   <div class="card-image waves-effect waves-block waves-light">
//     <img src='/images/{this.props.team_one.logo}.png' /> <img src='/images/{this.props.team_two.logo}.png' />
//   </div>
//   <div class="card-content">
//     <span class="card-title activator grey-text text-darken-4">
//     {this.props.team_one.name} {this.props.team_one.score} - {this.props.team_two.name} {this.props.team_two.score}
//     <i class="material-icons right">Match Stats</i></span>
//   </div>
//   <div class="card-reveal">
//     <span class="card-title grey-text text-darken-4">Match Stats<i class="material-icons right">Hide</i></span>
//     <p>Here are the stats</p>
//   </div>
// </div>