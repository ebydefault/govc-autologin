#   govc autologin

Too tired to type environment variables everytime I need to start a session,
too often I forgot to login before firing up some commands,
too paranoid to store my secret inside clear text file,
I wrote this small abusive script to help me with govc.

Now whenever I call it unauthenticated,
a humble interactive prompt will greet me to enter my credentials,
with invisible password typing,
before evaluating my command inside a new shell.

Just exit from the shell,
and all those credentials in my environment are gone.

##  How it works?

This is tricky.
A fake `govc` executable and a `bashrc` snippet are the playmakers.

Before logged-in,
they will masquerade the real `govc` from the path,
and supply the fake one.
And after logged-in,
they hide the fake one,
and will reveal the real `govc` to the path.

This masquerading and revealing mechanism is abusing shell executable path priority.

But I desperately need shell completion,
even before logged-in.
And this is the trickiest part.
So I shamelessly modified the `govc_bash_completion`
from [vmware/govmomi](https://github.com/vmware/govmomi).

#   Prerequisites

-   The fake `govc` needs the real one: [govc](https://github.com/vmware/govmomi/tree/master/govc).

-   For the `govc-vmid` and `govc-vmrc`: [jq](https://github.com/stedolan/jq).

-   For the `govc-vmrc` tool: [vmrc](https://kb.vmware.com/s/article/2091284).

The real `govc` does not need to be accessible from the path.
But both `jq` and `vmrc` should be.

#   Installation

1.  Fill in the `govc-autologin.conf` with your default govc environment.

    The real `govc` does not need to be accessible from the path beforehand.
    But then you must supply the real `govc` full path,
    and cannot simply use `GOVC_REAL_BIN="$(which govc)"`.

2.  Source the `govc-autologin.bash` from your `bashrc`, e.g.

    ```
    . ${HOME}/bin/govc-autologin/govc-autologin.bash
    ```

3.  Open a new shell, and all is set.

    Run `govc ls /` to test.

##  In case you're curious

4.  Run `which govc` and note the result.

5.  Fire up `exit`, and run `which govc` again.

    Note the difference with previous result.

#   Tools

Assuming each VM has a unique name accross vSphere datacenters,
you can get any VM ID or open its console only by its name.

For example:

-   `govc-vmid salt` to get the ID of salt VM.

-   `govc-vmrc ns1` to open ns1 VM console.

    Or better, simply call `vmrc ns1`.
    Since the real `vmrc` is overridden by `govc-vmrc` using alias,

#   Bugs

While this script and tools still work as expected,
sometimes I get both `govc-autologin` and `govc-autologin/tools` paths added twice.
Not sure for now, but I guess it's Konsole and yakuake messing up my environment variables.
