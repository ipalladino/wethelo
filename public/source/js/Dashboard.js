//VotingBoard
//responsible for retrieving specific Topic data and displaying it on its own section
var ViewTopic = React.createClass({
  loadTopicFromServer : function(){
    console.log("ViewTopic:loadTopicFromServer");
    if(this.state.itemId != undefined) {
      $.ajax({
        type : "GET",
        contentType: "application/json",
        url : "//localhost:3000/topics/"+this.state.itemId+".json",
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
    console.log("ViewTopic:setId");
    if(this.state == null) {
      this.state = {}
    }
    this.state.itemId = id;
    this.loadTopicFromServer();
  },

  render: function() {
    console.log("ViewTopic:render");
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

var CreateNewTopic = React.createClass({
  submitForm : function(e) {
    console.log("CreateNewTopic:submitForm");
    e.preventDefault();
    var currentEl = ReactDOM.findDOMNode(this);
    var data = {};
    $(currentEl).find("form").serializeArray().map(function(x){data[x.name] = x.value;});

    $.ajax({
      type : "POST",
      contentType: "application/json",
      url : "//localhost:3000/topics",
      dataType : "json",
      data : JSON.stringify(data),
      success : function(data) {
        votingBoard.loadTopicsFromServer();
      }
    });
  },
  render: function() {
    console.log("CreateNewTopic:render");
    return (
      <div>
        <form action="localhost:3000/topics" method="post">
          <div>
            <input placeholder="Topic Title" className="form-control" name="title" type="text" />
          </div>
          <div>
            <textarea placeholder="Topic Description" className="form-control" name="description" type="text"></textarea>
          </div>
          <a className="btn btn-default" onClick={this.submitForm} href="#" role="button">Create New Topic</a>
        </form>
      </div>
    )
  }
});


var createNewTopic = ReactDOM.render(
  <CreateNewTopic />,
  document.getElementById('create-topic')
);

var viewTopic = ReactDOM.render(
  <ViewTopic />,
  document.getElementById('view-topic')
);
