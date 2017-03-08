//VotingBoard
//responsible for retrieving specific Place data and displaying it on its own section
var ViewPlace = React.createClass({
  loadPlaceFromServer : function(){
    console.log("ViewPlace:loadPlaceFromServer");
    if(this.state.itemId != undefined) {
      $.ajax({
        type : "GET",
        contentType: "application/json",
        url : "//localhost:3000/places/"+this.state.itemId+".json",
        dataType : "json",
        success : function(data) {
          if(this.state == undefined) {
            this.state = {}
          }
          this.state.title = data.title;
          this.state.description = data.description;
          this.state.votes = data.votes;
          this.forceUpdate();
        }.bind(this)
      });
    }
  },

  setId :function(id){
    console.log("ViewPlace:setId");
    if(this.state == null) {
      this.state = {}
    }
    this.state.itemId = id;
    this.loadPlaceFromServer();
  },

  render: function() {
    console.log("ViewPlace:render");
    if(this.state == null) {
      return (
        <div>
          No element to display
        </div>
      )
    } else {
      return (
        <div className="panel panel-info">
          <div className="panel-heading">
            <strong>{this.state.title}</strong>
          </div>
          <div className="panel-body">{this.state.description}</div>
          <div className="panel-footer">Votes: {this.state.votes != null ? this.state.votes : 0}</div>
        </div>
      )
    }
  }
});

var CreateNewPlace = React.createClass({
  submitForm : function(e) {
    console.log("CreateNewPlace:submitForm");
    e.preventDefault();
    var currentEl = ReactDOM.findDOMNode(this);
    var data = {};
    $(currentEl).find("form").serializeArray().map(function(x){data[x.name] = x.value;});

    $.ajax({
      type : "POST",
      contentType: "application/json",
      url : "//localhost:3000/places",
      dataType : "json",
      data : JSON.stringify(data),
      success : function(data) {
        votingBoard.loadPlacesFromServer();
      }
    });
  },
  render: function() {
    console.log("CreateNewPlace:render");
    return (
      <div>
        <form action="localhost:3000/places" method="post">
          <div>
            <input placeholder="Place Title" className="form-control" name="title" type="text" />
          </div>
          <div>
            <textarea placeholder="Place Description" className="form-control" name="description" type="text"></textarea>
          </div>
          <a className="btn btn-default" onClick={this.submitForm} href="#" role="button">Create New Place</a>
        </form>
      </div>
    )
  }
});


var createNewPlace = ReactDOM.render(
  <CreateNewPlace />,
  document.getElementById('create-place')
);

var viewPlace = ReactDOM.render(
  <ViewPlace />,
  document.getElementById('view-place')
);
