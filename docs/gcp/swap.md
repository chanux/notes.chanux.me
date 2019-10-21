# GCP: SWAP

### Intro

GCP does not provide means to setup swap at provisioning time. Requests do so
are met with.. well [not a lot of
enthusiasm](https://googlecloudplatform.uservoice.com/forums/302595-compute-engine/suggestions/19044403-specify-swap-space-size-in-create-an-instance),
probably for very good reasons.

Discussions on [whether to use
SWAP](https://meta.discourse.org/t/create-a-swapfile-for-your-linux-server/13880/39)
on a modern system or not never comes with one size fits all answers.

So [read up](https://www.redhat.com/en/blog/do-we-really-need-swap-modern-systems),
understand your system and do what's right for you. Also check
[this](https://groups.google.com/forum/#!topic/gce-discussion/rFoLWNqn2l0)
interesting (but, ancient) discussion on swap vs. no-swap regarding GCE.

### For the lazy

(To be precise, for the lazy running modern day _servers_)

In the end, as a bit of a handwavy prescription for all, having swap on is like
having an insurance plan. When things go wrong, it'll be there helping by
slowing things down instead of making kernel killing something off.

It's unlikely to add much value when you have proper capacity planning,
dedicated resources for important services (say, database gets it's own VM),
proper configuration tuning in services, superb monitoring/alerting and a plan
on what to do when a spike hits.

All that is a lot of work. So it's ok to be lazy and throw in a swapfile and
let things slow down to a crawl when things go awry. Am I right?

Now comes the question whether to use separate disk, partition or swapfile for
swap. GCP PDs provides per GB IOPS values. But is it really worth having
a massive disk just for some SWAP? Continuing the tradition of handwavy generic
prescrption, I'd say just have a swapfile in the bootdisk.

**Update [2019-08-10]**

Someone with quite a bit of experience makes the case for [having a bit of swap
anyway](https://rachelbythebay.com/w/2019/08/08/swap/). So readup and use it in
your decision making process.

### Commands

Check which processes use swap

```
grep VmSize /proc/*/status | sort -n -r --key=2.1 | head -5
```

### Links

0. Adding [swapfile to centos 7](https://reiners.io/adding-swap-file-to-centos-7/) system.
- Adding [swapfile on GCE](https://badlywired.com/2016/08/adding-swap-google-compute-engine/)
- [Swap file vs Swap partition](https://lkml.org/lkml/2005/7/7/326)
- GCP Persistent Disk (PD) [performance](https://cloud.google.com/compute/docs/disks/performance)
- Btrfs is [not a good candidate](https://btrfs.wiki.kernel.org/index.php/FAQ#Does_btrfs_support_swap_files.3F) for putting a swapfile on
