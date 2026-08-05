import { useBackend, useLocalState } from '../backend';
import { Window } from '../layouts';
import {
  Box,
  Button,
  NoticeBox,
  Section,
  Stack,
  Tabs,
  Tooltip,
} from '../components';
import { Fragment } from 'inferno';
import { sanitizeText } from '../sanitize';

const ItemIcon = (props) => {
  const { icon, size = 20 } = props;
  return (
    <Box
      inline
      className="ds-icon"
      style={{
        width: size + 'px',
        height: size + 'px',
      }}>
      {!!icon && (
        <img
          src={icon}
          style={{
            width: '100%',
            height: '100%',
            'object-fit': 'contain',
            'image-rendering': 'pixelated',
          }}
        />
      )}
    </Box>
  );
};

const ItemButton = (props) => {
  const { item, selected, onClick } = props;
  return (
    <Button
      fluid
      compact
      selected={selected}
      onClick={onClick}
      color={item.free ? 'caution' : undefined}
      mb={0.2}>
      <Stack align="center">
        {!!item.icon && (
          <Stack.Item>
            <ItemIcon icon={item.icon} />
          </Stack.Item>
        )}
        <Stack.Item grow>{item.name}</Stack.Item>
        {!!item.free && (
          <Stack.Item className="ds-blood" bold>
            &lt;{item.free}&gt;
          </Stack.Item>
        )}
        <Stack.Item className="ds-readout ds-dim">
          {item.price} kg
        </Stack.Item>
      </Stack>
    </Button>
  );
};

const SpawnPointPicker = (props, context) => {
  const { act, data } = useBackend(context);
  const { spawn, spawnpoints = [] } = data;
  const { onClose } = props;
  return (
    <Section
      title="Select Spawnpoint"
      buttons={
        <Button icon="times" onClick={onClose}>
          Close
        </Button>
      }>
      <Stack vertical>
        {spawnpoints.map((point) => (
          <Stack.Item key={point.id}>
            <Stack>
              <Stack.Item grow>
                <Button
                  fluid
                  compact
                  selected={point.id === spawn?.id}
                  style={{ color: point.color }}
                  onClick={() =>
                    act('select_spawn_point', { id: point.id })
                  }>
                  {point.name}
                </Button>
              </Stack.Item>
              <Stack.Item>
                <Box className="ds-readout ds-dim">
                  {point.x}, {point.y}, {point.z}
                </Box>
              </Stack.Item>
              <Stack.Item>
                <Button
                  icon="crosshairs"
                  tooltip="Jump to this location"
                  onClick={() =>
                    act('jump', { x: point.x, y: point.y, z: point.z })
                  }
                />
              </Stack.Item>
            </Stack>
          </Stack.Item>
        ))}
      </Stack>
    </Section>
  );
};

export const NecroSpawnMenu = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    biomass,
    income,
    queue_fill,
    waiting_num,
    waiting_names = [],
    necromorphs = [],
    structures = [],
    current,
    place,
    total,
    authorised,
    spawn,
  } = data;
  const [category, setCategory] = useLocalState(context, 'category', 'necromorphs');
  const [pickerOpen, setPickerOpen] = useLocalState(context, 'pickerOpen', false);
  const items = category === 'necromorphs' ? necromorphs : structures;

  return (
    <Window width={620} height={520} theme="deadspace">
      <Window.Content>
        {pickerOpen ? (
          <SpawnPointPicker onClose={() => setPickerOpen(false)} />
        ) : (
          <Stack vertical fill>
            <Stack.Item>
              <Section>
                <Stack align="center">
                  <Stack.Item grow>
                    <Box className="ds-readout ds-amber" bold fontSize="1.4em">
                      BIOMASS {biomass}
                    </Box>
                    <Box className="ds-readout ds-dim" fontSize="0.9em">
                      +{income} / sec
                    </Box>
                  </Stack.Item>
                  <Stack.Item>
                    <Tooltip
                      content={
                        waiting_names.length
                          ? 'In necroqueue:\n' + waiting_names.join('\n')
                          : 'The necroqueue is empty.'
                      }>
                      <Box>
                        NECROQUEUE{' '}
                        <Box
                          inline
                          bold
                          className={waiting_num ? 'ds-amber' : 'ds-dim'}>
                          {waiting_num}
                        </Box>
                      </Box>
                    </Tooltip>
                  </Stack.Item>
                  <Stack.Item>
                    <Button
                      selected={queue_fill}
                      icon={queue_fill ? 'toggle-on' : 'toggle-off'}
                      tooltip="When enabled, newly spawned necromorphs are immediately possessed by a player waiting in the necroqueue."
                      onClick={() => act('toggle_queue')}>
                      Auto-Fill
                    </Button>
                  </Stack.Item>
                </Stack>
              </Section>
            </Stack.Item>
            <Stack.Item grow>
              <Stack fill>
                <Stack.Item basis="40%">
                  <Stack vertical fill>
                    <Stack.Item>
                      <Tabs fluid>
                        <Tabs.Tab
                          selected={category === 'necromorphs'}
                          onClick={() => setCategory('necromorphs')}>
                          Necromorphs
                        </Tabs.Tab>
                        <Tabs.Tab
                          selected={category === 'structures'}
                          onClick={() => setCategory('structures')}>
                          Structures
                        </Tabs.Tab>
                      </Tabs>
                    </Stack.Item>
                    <Stack.Item grow>
                      <Section fill scrollable>
                        {items.length ? (
                          items.map((item) => (
                            <ItemButton
                              key={item.name}
                              item={item}
                              selected={current && current.name === item.name}
                              onClick={() =>
                                act('select', { select: item.name })
                              }
                            />
                          ))
                        ) : (
                          <Box className="ds-dim">Nothing available.</Box>
                        )}
                      </Section>
                    </Stack.Item>
                  </Stack>
                </Stack.Item>
                <Stack.Item grow>
                  <Section fill scrollable title="Details">
                    {current ? (
                      <Fragment>
                        <Stack align="center" mb={0.5}>
                          {!!current.icon && (
                            <Stack.Item>
                              <ItemIcon icon={current.icon} size={40} />
                            </Stack.Item>
                          )}
                          <Stack.Item>
                            <Box bold fontSize="1.3em" className="ds-amber">
                              {current.name}
                            </Box>
                          </Stack.Item>
                        </Stack>
                        {!!current.reqtotal && (
                          <NoticeBox mb={1}>
                            Total Biomass: {total}/{current.reqtotal}
                            <br />
                            Total biomass includes biomass currently invested
                            in necromorphs and corruption nodes, whether
                            alive, or dead and being reclaimed.
                            <br />
                            This can be spawned for {current.price}kg biomass
                            once you accumulate enough total mass.
                          </NoticeBox>
                        )}
                        {!!current.event && (
                          <NoticeBox mb={1} color="danger">
                            {current.free} free necromorphs available from
                            event: {current.event}.
                            <br />
                            This necromorph can be spawned for free at an
                            associated spawnpoint.
                          </NoticeBox>
                        )}
                        <Box
                          dangerouslySetInnerHTML={{
                            __html: sanitizeText(current.desc),
                          }}
                        />
                      </Fragment>
                    ) : (
                      <Box className="ds-dim">Nothing selected.</Box>
                    )}
                  </Section>
                </Stack.Item>
              </Stack>
            </Stack.Item>
            <Stack.Item>
              <Section>
                <Stack align="center">
                  <Stack.Item grow>
                    <Box inline className="ds-dim">
                      SPAWNPOINT{' '}
                    </Box>
                    <Box inline bold style={{ color: spawn?.color }}>
                      {spawn?.name}
                    </Box>
                    <Box inline className="ds-readout ds-dim">
                      {' '}
                      ({spawn?.x}, {spawn?.y}, {spawn?.z})
                    </Box>
                  </Stack.Item>
                  <Stack.Item>
                    <Button icon="map-marker-alt" onClick={() => setPickerOpen(true)}>
                      {authorised ? 'Change' : 'Check'}
                    </Button>
                  </Stack.Item>
                  <Stack.Item>
                    <Button
                      color="caution"
                      disabled={!authorised}
                      onClick={() => act('spawn')}>
                      {place ? 'Place' : 'Spawn'}
                    </Button>
                  </Stack.Item>
                </Stack>
              </Section>
            </Stack.Item>
          </Stack>
        )}
      </Window.Content>
    </Window>
  );
};
