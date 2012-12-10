$(function() {
generateMatchups();
// Generate week/matchup dropdowns for nav bar
function generateMatchups() {
  $.each( matchups, function(w) {
    var weekNav = $('<li>').attr('class','dropdown'),
        weekLink = $('<a>')
                      .attr({
                          'id':'dweek'+w,
                          'href':'#',
                          'role':'button',
                          'class':'dropdown-toggle',
                          'data-toggle':'dropdown'
                          })
                      .html('Week '+w+' <b class="caret"></b>'),
        allLink = $('<li>').html('<a tabindex="-1" href="week/'+w+'/">All Matchups</a>'),
        weekList = $('<ul>').attr({'class':'dropdown-menu', 'role':'menu', 'aria-labelledby':'dweek'+w});
    weekLink.appendTo(weekNav);
    weekList.appendTo(weekNav);
    weekNav.appendTo('.nav');

    allLink.appendTo(weekList);

    $.each( matchups[w], function(i) {
      var matchupInfo = matchups[w][i],
          awayTeam = matchupInfo.away,
          homeTeam = matchupInfo.home,
          matchupNav = $('<li>'),
          matchupLink = $('<a>').attr({'class':'matchup','tabindex':'-1','href':'week/'+w+'/matchup/'+i+'/'})
                                .html('<img class="pull-left logoTiny" src="static/img/logo/'+awayTeam+'.gif">'+ awayTeam.toUpperCase() +' vs ' + homeTeam.toUpperCase() + '<img class="pull-right logoTiny" src="static/img/logo/'+homeTeam+'.gif">');
      matchupLink.appendTo(matchupNav);
      matchupNav.appendTo(weekList);
    });
  });
}

// Index page
if ( $('#index').length ) {
  var graph = new Rickshaw.Graph( {
    element: document.querySelector("#chart"),
    // width: 960,
    height: 500,
    renderer: 'bar',
    series: [
      {
        color: "#007883",
        data: data['football'],
        name: "Football Tweets"
      },
      {
        color: "#FF7883",
        data: data['nonfootball'],
        name: "Non-football Tweets"
      }
      ]
  });

  var legend = new Rickshaw.Graph.Legend( {
    graph: graph,
    element: document.getElementById('legend')
  } );

  var shelving = new Rickshaw.Graph.Behavior.Series.Toggle( {
    graph: graph,
    legend: legend
  });

  graph.render();

  var hoverDetail = new Rickshaw.Graph.HoverDetail( {
    graph: graph
  });

  var ticksTreatment = 'glow';

  var xAxis = new Rickshaw.Graph.Axis.Time( {
    graph: graph,
    ticksTreatment: ticksTreatment
  } );

  xAxis.render();

  var yAxis = new Rickshaw.Graph.Axis.Y( {
    graph: graph,
    tickFormat: Rickshaw.Fixtures.Number.formatKMBT,
    ticksTreatment: ticksTreatment
  } );

  yAxis.render();
}

// Teams page
if ( $('#teams').length ) {
  $.each(teams, function(i){
    var info = teams[i],
        entry = $('<div>')
                  .attr('class','teamListing')
                  .html('<a href="/teams/'+i+'"><img class="logoSmall" src="static/img/logo/'+i+'.gif"><span>'+info.name+'</span></a>');
    if (info.conf == "NFC") {
      entry.appendTo('#nfc');
    } else {
      entry.appendTo('#afc');
    }
  });
}

// Team page
if ( $('#team').length ) {
  var team = $('#team').data('team'),
      info = teams[team];
  $(document).attr('title', info.name+' | Pigskin | Visualizing Football Tweets');
  $('#teamName').text(info.name);
  $(".twitter-follow-button").attr('href','https://twitter.com/'+info.username).text('Follow @'+info.username);
  $('#teamTweets').html(teamCounts + ' tweets total about team');
    // Instantiate our graph!
  var graph = new Rickshaw.Graph( {
    element: document.querySelector("#chart"),
    // width: 800,
    height: 400,
    renderer: 'bar',
    series: [{
      color: info.color,
      data: teamCount,
      name: info.name
    }]
  });

  graph.render();

  var hoverDetail = new Rickshaw.Graph.HoverDetail( {
    graph: graph,
    formatter: function(series, x, y) {
      var date = '<span class="date">' + new Date((x * 1000) ).toUTCString() + '</span>';
      var swatch = '<span class="detail_swatch" style="background-color: ' + series.color + '"></span>';
      var content = swatch + series.name + ": " + parseInt(y) + '<br>' + date;
      return content;
    }
  } );

  // var legend = new Rickshaw.Graph.Legend( {
  //   graph: graph,
  //   element: document.getElementById('legend')
  // } );

  // var shelving = new Rickshaw.Graph.Behavior.Series.Toggle( {
  //   graph: graph,
  //   legend: legend
  // });

  var ticksTreatment = 'glow';

  var xAxis = new Rickshaw.Graph.Axis.Time( {
    graph: graph,
    ticksTreatment: ticksTreatment
  } );

  xAxis.render();

  var yAxis = new Rickshaw.Graph.Axis.Y( {
    graph: graph,
    tickFormat: Rickshaw.Fixtures.Number.formatKMBT,
    ticksTreatment: ticksTreatment
  } );

  yAxis.render();
}

// Week page
if ( $('#week').length ) {
  // console.log(teamData);
  // console.log(trendingTopics);
  $.each(trendingTopics, function(i){
    $("<li>").text(trendingTopics[i]["term"]).appendTo("#trending");
  });

  var seriesData = [];
  $.each(teamData, function(i){
      var seriesEntry = {};
      seriesEntry.color = teams[i]["color"];
      seriesEntry.data = teamData[i][week];
      seriesEntry.name = teams[i]["name"];
      seriesData.push(seriesEntry);
  });

  // Instantiate our graph!
  var graph = new Rickshaw.Graph( {
    element: document.querySelector("#chart"),
    // width: 800,
    height: 400,
    renderer: 'line',
    series: seriesData
  });

  graph.render();

  var hoverDetail = new Rickshaw.Graph.HoverDetail( {
    graph: graph,
    formatter: function(series, x, y) {
      var date = '<span class="date">' + new Date((x * 1000) ).toUTCString() + '</span>';
      var swatch = '<span class="detail_swatch" style="background-color: ' + series.color + '"></span>';
      var content = swatch + series.name + ": " + parseInt(y) + '<br>' + date;
      return content;
    }
  } );

  var legend = new Rickshaw.Graph.Legend( {
    graph: graph,
    element: document.getElementById('legend')
  } );

  var shelving = new Rickshaw.Graph.Behavior.Series.Toggle( {
    graph: graph,
    legend: legend
  });

  var slider = new Rickshaw.Graph.RangeSlider( {
    graph: graph,
    element: $('#slider')
  } );

  var ticksTreatment = 'glow';

  var xAxis = new Rickshaw.Graph.Axis.Time( {
    graph: graph,
    ticksTreatment: ticksTreatment
  } );

  xAxis.render();

  var yAxis = new Rickshaw.Graph.Axis.Y( {
    graph: graph,
    tickFormat: Rickshaw.Fixtures.Number.formatKMBT,
    ticksTreatment: ticksTreatment
  } );

  yAxis.render();

}

// Matchup page
if ( $('#matchup').length ) {
  var currentMatchup = matchup.split("_"), //split matchup into the different teams
      awayTeam = currentMatchup[0],
      homeTeam = currentMatchup[1],
      matchupInfo = matchups[week][matchup];

  $("#matchupLocation").html(matchupInfo["stadium"]);
  $("#matchupScore").html(matchupInfo["awayScore"] +' - '+ matchupInfo["homeScore"]);

  $('#away img').attr("src","static/img/logo/"+awayTeam+".gif");
  $('#home img').attr("src","static/img/logo/"+homeTeam+".gif");

  $('#away h3').text(teams[awayTeam]["name"]);
  $('#home h3').text(teams[homeTeam]["name"]);

  $("#away .twitter-follow-button").attr('href','https://twitter.com/'+teams[awayTeam]["username"]).text('Follow @'+teams[awayTeam]["username"]);
  $("#home .twitter-follow-button").attr('href','https://twitter.com/'+teams[homeTeam]["username"]).text('Follow @'+teams[homeTeam]["username"]);

  var awayTopTen = topTen[awayTeam][awayTeam];
  $.each(awayTopTen, function(i){
      $("<li>").html('<a href="https://twitter.com/'+awayTopTen[i]["username"]+'">@' + awayTopTen[i]["username"]+'</a> | '+ awayTopTen[i]["fb_weight"] +' | '+ awayTopTen[i]["tweet"]).appendTo('#awayTopTen');
  });

  var homeTopTen = topTen[homeTeam][homeTeam];
  $.each(awayTopTen, function(i){
      $("<li>").html('<a href="https://twitter.com/'+homeTopTen[i]["username"]+'">@' + homeTopTen[i]["username"]+'</a> | '+ homeTopTen[i]["fb_weight"] +' | '+ homeTopTen[i]["tweet"] ).appendTo('#homeTopTen');
  });

  // Instantiate our graph!
  var graph = new Rickshaw.Graph( {
    element: document.querySelector("#chart"),
    // width: 800,
    height: 400,
    renderer: 'line',
    series: [
      {
        color: teams[awayTeam]["color"],
        data: teamData[awayTeam][week],
        name: teams[awayTeam]["name"]
      },
      {
        color: teams[homeTeam]["color"],
        data: teamData[homeTeam][week],
        name: teams[homeTeam]["name"]
      }
      ]
  });

  // graph.renderer.unstack = true;
  graph.render();

  // var hoverDetail = new Rickshaw.Graph.HoverDetail( {
  //   graph: graph
  // } );

  var hoverDetail = new Rickshaw.Graph.HoverDetail( {
    graph: graph,
    formatter: function(series, x, y) {
      var date = '<span class="date">' + new Date((x * 1000) ).toUTCString() + '</span>';
      var swatch = '<span class="detail_swatch" style="background-color: ' + series.color + '"></span>';
      var content = swatch + series.name + ": " + parseInt(y) + '<br>' + date;
      return content;
    }
  } );


  var legend = new Rickshaw.Graph.Legend( {
    graph: graph,
    element: document.getElementById('legend')
  } );

  var shelving = new Rickshaw.Graph.Behavior.Series.Toggle( {
    graph: graph,
    legend: legend
  });

  var slider = new Rickshaw.Graph.RangeSlider( {
    graph: graph,
    element: $('#slider')
  } );

    // var axes = new Rickshaw.Graph.Axis.Time( {
    //   graph: graph
    // } );
    // axes.render();

  var ticksTreatment = 'glow';

  var xAxis = new Rickshaw.Graph.Axis.Time( {
    graph: graph,
    ticksTreatment: ticksTreatment
  } );

  xAxis.render();

  var yAxis = new Rickshaw.Graph.Axis.Y( {
    graph: graph,
    tickFormat: Rickshaw.Fixtures.Number.formatKMBT,
    ticksTreatment: ticksTreatment
  } );

  yAxis.render();


}


});
