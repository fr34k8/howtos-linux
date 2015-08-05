# snmp

Übersetzung von SNMP OID’s zur Beschreibung.

	$ snmptranslate -Td 1.3.6.1.4.1.2021.11.53.0

> UCD-SNMP-MIB::ssCpuRawIdle.0
> ssCpuRawIdle OBJECT-TYPE
> -- FROM UCD-SNMP-MIB
> SYNTAX  Counter32
> MAX-ACCESS  read-only
> STATUS  current
> DESCRIPTION "The number of 'ticks' (typically 1/100s) spent idle.

> On a multi-processor system, the 'ssCpuRaw*'
> counters are cumulative over all CPUs, so their
> sum will typically be N*100 (for N processors)."
