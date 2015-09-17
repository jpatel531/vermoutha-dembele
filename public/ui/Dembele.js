var FIELDS = [
  'Goals',
  'Shots',
  'Shots on Target',
  'Possession',
  'Corners',
  'Fouls',
  'Tackles',
  'Pass Accuracy',
  'Shot Accuracy'
]


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
      <div className="container">
        <h1 className="center-align">Vermoutha Dembele </h1>
        <div className="row">
        {matches}
        </div>
      </div>
    );
  }

});

React.render(<Dembele />, document.getElementById('app'));



var Match = React.createClass({

  render: function() {

    var match = this.props.match;

    var imageStyle = {height: 300, width: 500};

    return (
      <div className="col m6">
        <div className="card">
          <div className="card-image waves-effect waves-block waves-light">
            <img src="http://i1.mirror.co.uk/incoming/article1455418.ece/ALTERNATES/s615/Kolo%20Toure" style={imageStyle} />
          </div>
          <div className="card-content">
            <span className="card-title activator grey-text text-darken-4">
            {match.name_of_the_leftside_team} {match.leftside_goals} - {match.rightside_goals} {match.name_of_the_rightside_team}
            <i className="material-icons right">Match Stats</i></span>
          </div>
          <div className="card-reveal">
            <span className="card-title grey-text text-darken-4">Match Stats<i className="material-icons right">Hide</i></span>
            <p>Here are the stats</p>
            <StatsTable match={match} />
          </div>
        </div>
      </div>
    );
  }

});

var StatsTable = React.createClass({

  render: function() {

    var match = this.props.match;

    var fieldNames = FIELDS.map(function(field){
      return field.toLowerCase().replace(/ /g, '_');
    });

    var fields = FIELDS.map(function(field){
      var fieldKey = field.toLowerCase().replace(/ /g, '_');
      var leftStat = match['leftside_' + fieldKey];
      var rightStat = match['rightside_' + fieldKey];
      var name = field;
      return (
        <tr>
          <td>{leftStat}</td>
          <td>{field}</td>
          <td>{rightStat}</td>
        </tr>
      );
    });

    return (

      <table className="striped centered">
        <thead>
          <tr>
              <th>{match.name_of_the_leftside_team}</th>
              <th> Field </th>
              <th>{match.name_of_the_rightside_team}</th>
          </tr>
        </thead>

        <tbody>

          {fields}

        </tbody>
      </table>
          

    );
  }

});