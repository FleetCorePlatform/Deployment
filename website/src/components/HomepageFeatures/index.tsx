import type {ReactNode} from 'react';
import clsx from 'clsx';
import Heading from '@theme/Heading';
import styles from './styles.module.css';

type FeatureItem = {
  title: string;
  Svg: React.ComponentType<React.ComponentProps<'svg'>>;
  description: ReactNode;
};

const FeatureList: FeatureItem[] = [
  {
    title: 'Fleet Management',
    Svg: require('@site/static/img/feature_fleet.svg').default,
    description: (
      <>
        Group your drones into outposts and manage survey missions from a centralized, 
        geospatial-aware control plane.
      </>
    ),
  },
  {
    title: 'Real-time Operations',
    Svg: require('@site/static/img/feature_realtime.svg').default,
    description: (
      <>
        Low-latency WebRTC video streaming and manual control via Gamepad (WebHID) 
        integrated directly into the Desktop GCS.
      </>
    ),
  },
  {
    title: 'Intelligent Planning',
    Svg: require('@site/static/img/feature_intelligent.svg').default,
    description: (
      <>
        Recursive Binary Space Partitioning and Boustrophedon path generation algorithms 
        ensure optimal mission distribution across the fleet.
      </>
    ),
  },
];

function Feature({title, Svg, description}: FeatureItem) {
  return (
    <div className={clsx('col col--4')}>
      <div className="text--center">
        <Svg className={styles.featureSvg} role="img" />
      </div>
      <div className="text--center padding-horiz--md">
        <Heading as="h3">{title}</Heading>
        <p>{description}</p>
      </div>
    </div>
  );
}

export default function HomepageFeatures(): ReactNode {
  return (
    <section className={styles.features}>
      <div className="container">
        <div className="row">
          {FeatureList.map((props, idx) => (
            <Feature key={idx} {...props} />
          ))}
        </div>
      </div>
    </section>
  );
}
