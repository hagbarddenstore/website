+++
date = "2015-04-16T20:38:00+02:00"
draft = false
title = "IP addresses"
slug = "ip-addresses"
tags = [ "cidr", "ip address", "netmask", "infrastructure", "network" ]
categories = [ "Infrastructure" ]
+++

TL;DR;

A cheat sheet to IPv4 subnetting and other quirks. Common subnet configurations
with CIDR and netmask notation.

<!--more-->

### Disclaimer

I'm no expert in IPv4 networking, I've simply learnt stuff as I needed it. This
post is mostly a cheat sheet for me, when I need to setup some infrastructure.

### Private networks

There are three private address spaces currently in use.

* 127.0.0.0/18 - Not exactly a private network, but a reserved range for
  loopback intefaces.
* 10.0.0.0/8 - 16,777,216 addresses
* 172.16.0.0/12 - 1,048,576 addresses
* 192.168.0.0/24 - 65,536 addresses

In networks ranging from /1 to /30, there are always two addresses that are
unusable as host addresses. They are the first address and last address.
Example, in a 192.168.1.0/24 subnet, the address 192.168.1.0 and 192.168.1.255
are reserved as network address and broadcast address.

Since addresses are divided into 4 groups and and 32 (The CIDR bit) is dividable
by 4, we can form this rule of thumb:

* If CIDR is lower than 8, it changes all groups.
* If CIDR is lower than 16 but higher or equal to 8, it changes the last three
  groups.
* If CIDR is lower than 24 but higher or equal to 16, it changes the last two
  groups.
* If CIDR is higher or equal to 24, it changes the last group only.

Examples: A /8 network ranges from \*.0.0.0 to \*.255.255.255, a /16 network
ranges from \*.\*.0.0 to \*.\*.255.255 and thus a /24 network ranges from
\*.\*.\*.0 to \*.\*.\*.255.

### Table of netmasks

<table class="table table-condensed">
    <thead>
        <tr>
            <th>CIDR</th>
            <th>Netmask</th>
            <th>Hosts</th>
            <th>Usable hosts</th>
            <th>Comments</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>1</td>
            <td>128.0.0.0</td>
            <td>2,147,483,648</td>
            <td>2,147,483,646</td>
            <td></td>
        </tr>
        <tr>
            <td>2</td>
            <td>192.0.0.0</td>
            <td>1,073,741,824</td>
            <td>1,073,741,822</td>
            <td></td>
        </tr>
        <tr>
            <td>3</td>
            <td>224.0.0.0</td>
            <td>536,870,912</td>
            <td>536,870,910</td>
            <td></td>
        </tr>
        <tr>
            <td>4</td>
            <td>240.0.0.0</td>
            <td>268,435,456</td>
            <td>268,435,454</td>
            <td></td>
        </tr>
        <tr>
            <td>5</td>
            <td>248.0.0.0</td>
            <td>134,217,728</td>
            <td>134,217,726</td>
            <td></td>
        </tr>
        <tr>
            <td>6</td>
            <td>252.0.0.0</td>
            <td>67,108,864</td>
            <td>67,108,862</td>
            <td></td>
        </tr>
        <tr>
            <td>7</td>
            <td>254.0.0.0</td>
            <td>33,554,432</td>
            <td>33,554,430</td>
            <td></td>
        </tr>
        <tr>
            <td>8</td>
            <td>255.0.0.0</td>
            <td>16,777,216</td>
            <td>16,777,214</td>
            <td>Class A</td>
        </tr>
        <tr>
            <td>9</td>
            <td>255.128.0.0</td>
            <td>8,388,608</td>
            <td>8,388,606</td>
            <td></td>
        </tr>
        <tr>
            <td>10</td>
            <td>255.192.0.0</td>
            <td>4,194,304</td>
            <td>4,194,302</td>
            <td></td>
        </tr>
        <tr>
            <td>11</td>
            <td>255.224.0.0</td>
            <td>2,097,152</td>
            <td>2,097,150</td>
            <td></td>
        </tr>
        <tr>
            <td>12</td>
            <td>255.240.0.0</td>
            <td>1,048,576</td>
            <td>1,048,574</td>
            <td></td>
        </tr>
        <tr>
            <td>13</td>
            <td>255.248.0.0</td>
            <td>524,288</td>
            <td>524,286</td>
            <td></td>
        </tr>
        <tr>
            <td>14</td>
            <td>255.252.0.0</td>
            <td>262,144</td>
            <td>262,142</td>
            <td></td>
        </tr>
        <tr>
            <td>15</td>
            <td>255.254.0.0</td>
            <td>131,072</td>
            <td>131,070</td>
            <td></td>
        </tr>
        <tr>
            <td>16</td>
            <td>255.255.0.0</td>
            <td>65,536</td>
            <td>65,534</td>
            <td>Class B</td>
        </tr>
        <tr>
            <td>17</td>
            <td>255.255.128.0</td>
            <td>32,768</td>
            <td>32,766</td>
            <td></td>
        </tr>
        <tr>
            <td>18</td>
            <td>255.255.192.0</td>
            <td>16,384</td>
            <td>16,382</td>
            <td></td>
        </tr>
        <tr>
            <td>19</td>
            <td>255.255.224.0</td>
            <td>8,192</td>
            <td>8,190</td>
            <td></td>
        </tr>
        <tr>
            <td>20</td>
            <td>255.255.240.0</td>
            <td>4,096</td>
            <td>4,094</td>
            <td></td>
        </tr>
        <tr>
            <td>21</td>
            <td>255.255.248.0</td>
            <td>2,048</td>
            <td>2,046</td>
            <td></td>
        </tr>
        <tr>
            <td>22</td>
            <td>255.255.252.0</td>
            <td>1,024</td>
            <td>1,022</td>
            <td></td>
        </tr>
        <tr>
            <td>23</td>
            <td>255.255.254.0</td>
            <td>512</td>
            <td>510</td>
            <td></td>
        </tr>
        <tr>
            <td>24</td>
            <td>255.255.255.0</td>
            <td>256</td>
            <td>254</td>
            <td>Class C</td>
        </tr>
        <tr>
            <td>25</td>
            <td>255.255.255.128</td>
            <td>128</td>
            <td>126</td>
            <td></td>
        </tr>
        <tr>
            <td>26</td>
            <td>255.255.255.192</td>
            <td>64</td>
            <td>62</td>
            <td></td>
        </tr>
        <tr>
            <td>27</td>
            <td>255.255.255.224</td>
            <td>32</td>
            <td>30</td>
            <td></td>
        </tr>
        <tr>
            <td>28</td>
            <td>255.255.255.240</td>
            <td>16</td>
            <td>14</td>
            <td></td>
        </tr>
        <tr>
            <td>29</td>
            <td>255.255.255.248</td>
            <td>8</td>
            <td>6</td>
            <td></td>
        </tr>
        <tr>
            <td>30</td>
            <td>255.255.255.252</td>
            <td>4</td>
            <td>2</td>
            <td></td>
        </tr>
        <tr>
            <td>31</td>
            <td>255.255.255.254</td>
            <td>2</td>
            <td>2</td>
            <td></td>
        </tr>
        <tr>
            <td>32</td>
            <td>255.255.255.255</td>
            <td>1</td>
            <td>1</td>
            <td></td>
        </tr>
    </tbody>
</table>

### Table of ranges