var watchman = require('fb-watchman');
var client = new watchman.Client();
const exec = require('child_process').exec;

var dir_of_interest = __dirname + '/src';

function make_time_constrained_subscription(client, watch, relative_path) {
  client.command(['clock', watch], function(error, resp) {
    if (error) {
      console.error('Failed to query clock:', error);
      return;
    }

    sub = {
      // Match any `.js` file in the dir_of_interest
      expression: ['allof', ['match', '*.js']],
      // Which fields we're interested in
      fields: ['name', 'size', 'exists', 'type'],
      // add our time constraint
      since: resp.clock,
    };

    if (relative_path) {
      sub.relative_root = relative_path;
    }

    client.command(['subscribe', watch, 'mysubscription', sub], function(error, resp) {
      // handle the result here
    });
    client.on('subscription', function(resp) {
      if (resp.subscription !== 'mysubscription') return;

      resp.files.forEach(function(file) {
        // convert Int64 instance to javascript integer

        console.log('File changed: ' + file.name);
        console.log('⏳  Updating');
        exec(__dirname + '/local.sh', (error, stdout, stderr) => {
          if (error !== null) {
            console.log(`exec error: ${error}`);
          }
          console.log('✅  Updated /opt');
        });
      });
    });
  });
}

client.capabilityCheck({ optional: [], required: ['relative_root'] }, function(error, resp) {
  if (error) {
    console.log(error);
    client.end();
    return;
  }

  // Initiate the watch
  client.command(['watch-project', dir_of_interest], function(error, resp) {
    if (error) {
      console.error('Error initiating watch:', error);
      return;
    }

    // It is considered to be best practice to show any 'warning' or
    // 'error' information to the user, as it may suggest steps
    // for remediation
    if ('warning' in resp) {
      console.log('warning: ', resp.warning);
    }

    // `watch-project` can consolidate the watch for your
    // dir_of_interest with another watch at a higher level in the
    // tree, so it is very important to record the `relative_path`
    // returned in resp

    console.log('watch established on ', resp.watch, ' relative_path', resp.relative_path);
    make_time_constrained_subscription(client, resp.watch, resp.relative_path);
  });
});
