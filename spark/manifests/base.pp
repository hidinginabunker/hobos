exec {'apt-get update':
    path => '/usr/bin'
}


package {'scala':
    ensure  => installed,
    require => Exec['apt-get update']
}

package {'git':
    ensure  => installed
}

exec {'wget-spark':
    command => "wget 'http://spark-project.org/download/spark-0.7.2-sources.tgz' -O /tmp/spark-0.7.2-sources.tgz",
    timeout => 1200,
    creates => "/tmp/spark-0.7.2-sources.tgz",
    path    => '/usr/bin'
}

exec {'untar-spark':
    command => 'tar -zxvf /tmp/spark-0.7.2-sources.tgz -C /tmp/',
    require => Exec['wget-spark'],
    creates => '/tmp/spark-0.7.2-sources',
    path    => '/usr/bin'
}

exec {'build-spark':
    command => 'sbt/sbt package',
    cwd     => '/tmp/spark-0.7.2-sources',
    path    => '/usr/bin',
    require => [Exec['untar-spark'], Package['git']]
}
