# sshkit-mco-rpc-bug

## Usage

1. Clone this repo.

2. Install the sshkit gem by doing a `bundle install`.

3. Clone the example Vagrant MCO repo: `git clone git@github.com:ripienaar/mcollective-vagrant.git`

4. Set the number of instances to 1 on line 6 of the `Vagrantfile`: `INSTANCES=1`

5. Bring up the `middleware` VM and `node0` VM by running `vagrant up`.

6. Running `mco_package_success.rb` should work: `$ ruby mco_package_success.rb`

7. Running `mco_rpc_failure.rb` should hang: `$ ruby mco_rpc_failure.rb`

## Testing manually

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
