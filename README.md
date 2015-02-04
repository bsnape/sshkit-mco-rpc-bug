# sshkit-mco-rpc-bug

Here are 3 methods to execute SSH commands on a server (actually a Vagrant VM).

For some reason, MCollective RPC commands only work with Capistrano 2.

Here's a breakdown of the methods attempted:

1. **Capistrano 2** - RPC works.
2. **SSHKit** (powers Capistrano 3) - RPC does not work.
3. **Custom Ruby SSH implementation** (using `net/ssh`) - RPC does not work.

In this repo I run two `mco` commands that report the health of `httpd`.
One command uses the `mco` `rpc` agent, one uses the `service` agent.
The `rpc` agent is the one we're having trouble with.

## Setup

1. Clone this repo.

2. Install all gems by doing a `bundle install --binstubs`.

3. Clone the example Vagrant MCO repo: `git clone git@github.com:ripienaar/mcollective-vagrant.git`

4. Set the number of instances to 1 on line 6 of the `Vagrantfile`: `INSTANCES=1`

5. Bring up the `middleware` VM and `node0` VM by running `vagrant up`.

## Verification

### SSHKit

Running `sshkit_success.rb` works:

```
$ ruby sshkit_success.rb
INFO [8738ec48] Running /usr/bin/env mco service status httpd on 192.168.2.10
INFO [8738ec48] Finished in 0.358 seconds with exit status 0 (successful).
```

Running `sshkit_failure.rb` hangs:

```
$ ruby sshkit_failure.rb
INFO [b61f54e9] Running /usr/bin/env mco rpc service status service=httpd --json on 192.168.2.10
````

### Custom SSH

Running `shell_success.rb` works:

```
$ ruby shell_success.rb
I, [2015-02-04T14:26:47.619931 #41975]  INFO -- : Executing SSH command: mco service status httpd
I, [2015-02-04T14:26:47.911420 #41975]  INFO -- :
2 / 2

        node0.example.net: stopped
   middleware.example.net: stopped

Summary of Service Status:

   stopped = 2


Finished processing 2 / 2 hosts in 79.04 ms
```

Running `shell_failure.rb` hangs:

```
$ ruby shell_failure.rb
I, [2015-02-04T14:27:08.339763 #41987]  INFO -- : Executing SSH command: mco rpc service status service=httpd --json
````

### Capistrano 2

Running `bin/cap vagrant cap2_success` works:

```
$ bin/cap vagrant cap2_success
  * 2015-02-04 14:28:10 executing `vagrant'
    triggering start callbacks for `cap2_success'
  * 2015-02-04 14:28:10 executing `multistage:ensure'
  * 2015-02-04 14:28:10 executing `cap2_success'
  * executing "mco rpc -j puppet status"
    servers: ["192.168.2.10"]
    [192.168.2.10] executing command
    command finished in 221ms
Got stdout data >>>[{"statuscode":0,"sender":"node0.example.net","data":{"idling":false,"status":"stopped","since_lastrun":94577,"daemon_present":false,"enabled":true,"message":"Currently stopped; last completed run 1 day 2 hours 16 minutes 17 seconds ago","disable_message":"","applying":false,"lastrun":1422965457},"statusmsg":"OK","agent":"puppet","action":"status"},{"statuscode":0,"sender":"middleware.example.net","data":{"idling":false,"status":"stopped","since_lastrun":94841,"daemon_present":false,"enabled":true,"message":"Currently stopped; last completed run 1 day 2 hours 20 minutes 41 seconds ago","disable_message":"","applying":false,"lastrun":1422965193},"statusmsg":"OK","agent":"puppet","action":"status"}]
<<<
```

Running the command that failed via other methods `bin/cap vagrant cap2_failure` **actually works**:

```
$ bin/cap vagrant cap2_failure
  * 2015-02-04 14:29:15 executing `vagrant'
    triggering start callbacks for `cap2_failure'
  * 2015-02-04 14:29:15 executing `multistage:ensure'
  * 2015-02-04 14:29:15 executing `cap2_failure'
  * executing "mco rpc service status service=httpd --json"
    servers: ["192.168.2.10"]
    [192.168.2.10] executing command
    command finished in 293ms
Got stdout data >>>[{"statuscode":0,"sender":"node0.example.net","data":{"status":"stopped"},"statusmsg":"OK","agent":"service","action":"status"},{"statuscode":0,"sender":"middleware.example.net","data":{"status":"stopped"},"statusmsg":"OK","agent":"service","action":"status"}]
<<<
```

## Testing manually

For extra confirmation, we can run the commands manually:

Using the MCO service agent works fine.

```
[vagrant@middleware ~]$ mco service status httpd

 * [ ============================================================> ] 2 / 2

   middleware.example.net: stopped
        node0.example.net: stopped

Summary of Service Status:

   stopped = 2


Finished processing 2 / 2 hosts in 77.73 ms
```

The RPC command for the same operation also works fine manually.

```
[vagrant@middleware ~]$ mco rpc service status service=httpd --json
[
  {
    "statuscode": 0,
    "sender": "node0.example.net",
    "data": {
      "status": "stopped"
    },
    "statusmsg": "OK",
    "agent": "service",
    "action": "status"
  },
  {
    "statuscode": 0,
    "sender": "middleware.example.net",
    "data": {
      "status": "stopped"
    },
    "statusmsg": "OK",
    "agent": "service",
    "action": "status"
  }
]
```
