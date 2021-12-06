# Demystifying-OpenOCD

How often does OpenOCD seem to crash or mis-perform for no apparent reason? Do you feel like you're back to trial-and-error mode?

Here are a bunch of overrides for the start-up process, proper delays, handling of those ever so common (and annoying) failures during <i>scan</i> and <i>examine</i>. Also included are a couple suggestions for high level loading procedures for <b>ram</b> and <b>rom</b> destinations.

These tips will give a very useful, brief, and highly readable log of all progress steps that OpenOCD goes through -- and you can see at exactly which step those <i>Messages</i>, <i>Warnings</i>, and <i>Errors</i> from from!

The linker script .lds file can be revised for <b>ram</b> or <b>rom</b> targets in the <code>.text</code> and <code>.rodata</code> sections; or, a separate script can be made for each and selected in turn by different makefiles or makefile command line arguments or options.

Then in the makefile, for example, <code>fe310.mk</code>, you would have a pair of link instructions where the last line (indented with tab, of course) invokes the <code>openocd</code> program -- which I presume is already specified in your system path.

So that at the command line, to do a full build (compile, assemble, link, load, and target device erase, program, and verify) <i>the smallest toolchain in the world</i> is easy:
<pre>
make -f fe310.mk rom
or
make -f fe310.mk ram
</pre>


For more information, see full discussion at https://forums.sifive.com/t/correct-plic-claim-complete-register-addresses/5455/2
