#!/bin/sh

cat << EOM
to: alex@courtis.org
from: lord <alex@courtis.org>
subject: $(hostname) ${1}
MIME-Version: 1.0
Content-Type: text/html

<pre>
EOM

