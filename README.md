# iP Relay #

iP Relay is a message relaying service built for the use of the engineering, testing, and project management teams at [Interactive Partners](http://www.ipartners.com/). It's primary purpose, at least for the moment, is to provide users of the Beanstalk source control system the ability to execute a few commands directly in commit messages.

## Message Origins ##

### [Beanstalk](http://beanstalkapp.com/) ###

To configure:

  1. Open a repository
  2. Go to: Setup -> Integration -> Web hooks
  3. For SVN repositories, activate and point to this URL: http://ip-relay.your_domain_here.com/beanstalk/commit
  4. For Git repositories, activate and point to this URL: http://ip-relay.your_domain_here.com/beanstalk/payload

Command syntax:

  * Surround each command in square brackets
  * Separate parameters with a comma
  * Separate parameter keys and values with a colon
  * Multiple commands are supported
  * Spaces are automatically stripped

Commit message examples:

`Fixing 'Broken pipe' error [task: 3907] [chat:shenanigans]`

  * Adds a comment to Intervals task 3907
  * Speaks in the Campfire chat room "Shenanigans"

`Updated schema [bug: 100, status: resolved] [bug: 101]`

  * Adds a comment to Bugzilla bug 100
  * Changes the status of Bugzilla bug 100 to "RESOLVED"
  * Adds a comment to Bugzilla bug 101
  
### [Hoptoad](http://www.hoptoadapp.com/) ###

Hoptoad errors can be automatically filed as bugs in Bugzilla.

To configure:

  1. Install [hoptoad-webhooks](https://github.com/halorgium/hoptoad-webhooks) by @halorgium
  2. Configure the hoptoad-webhooks `hook_url` to be: http://ip-relay.your_domain_here.com/hoptoad/error
  3. Match the project names between Hoptoad and Bugzilla (there is currently no mapping capability available)
  4. For each project in Bugzilla, create a "Hoptoad Errors" component — this will be the "inbox" for new Hoptoad error reports

## Message Destinations ##

The following message "destinations" are supported:

### [Bugzilla](http://www.bugzilla.org/) ###

Example: `[bug: 100, status: resolved] [bug: 101]`

Note: Status value is automatically upper-cased (ex. "RESOLVED").

### [Intervals](http://www.myintervals.com/) ###

Example: `[task: 3907]`

### [Campfire](http://campfirenow.com/) ###

Example: `[chat:shenanigans]`

Note: Room name is automatically capitalized (ex. "Shenanigans").