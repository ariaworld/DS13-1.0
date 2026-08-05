import { useBackend } from '../backend';
import { Window } from '../layouts';
import { Box, Button, ProgressBar, Section, Stack } from '../components';
import { Fragment } from 'inferno';
import { sanitizeText } from '../sanitize';

const formatCooldown = (deciseconds) => {
  const seconds = Math.ceil(deciseconds / 10);
  if (seconds < 60) {
    return seconds + 's';
  }
  const mins = Math.floor(seconds / 60);
  const secs = seconds % 60;
  return mins + 'm ' + secs + 's';
};

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

const AbilityButton = (props) => {
  const { ability, selected, onClick } = props;
  const onCooldown = !!ability.cooldown;
  return (
    <Button
      fluid
      compact
      selected={selected}
      onClick={onClick}
      mb={0.2}>
      <Stack align="center">
        {!!ability.icon && (
          <Stack.Item>
            <ItemIcon icon={ability.icon} />
          </Stack.Item>
        )}
        <Stack.Item grow>{ability.name}</Stack.Item>
        {onCooldown ? (
          <Stack.Item className="ds-blood ds-readout">
            {formatCooldown(ability.cooldown)}
          </Stack.Item>
        ) : (
          <Stack.Item className="ds-readout ds-dim">
            {ability.cost}
          </Stack.Item>
        )}
      </Stack>
    </Button>
  );
};

export const AbilitiesMenu = (props, context) => {
  const { act, data } = useBackend(context);
  const { energy, income, max_energy, abilities = [], current } = data;
  const currentAbility =
    current && abilities.find((ability) => ability.id === current.id);
  const canCast = !!current && !(currentAbility && currentAbility.cooldown);

  return (
    <Window width={620} height={520} theme="deadspace">
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item>
            <Section>
              <Stack align="center">
                <Stack.Item grow>
                  <Box className="ds-readout ds-amber" bold fontSize="1.2em">
                    PSI ENERGY
                  </Box>
                  <ProgressBar value={energy} minValue={0} maxValue={max_energy}>
                    {energy} / {max_energy}
                  </ProgressBar>
                </Stack.Item>
                <Stack.Item className="ds-readout ds-dim">
                  +{income} / sec
                </Stack.Item>
              </Stack>
            </Section>
          </Stack.Item>
          <Stack.Item grow>
            <Stack fill>
              <Stack.Item basis="35%">
                <Section fill scrollable title="Abilities">
                  {abilities.length ? (
                    abilities.map((ability) => (
                      <AbilityButton
                        key={ability.id}
                        ability={ability}
                        selected={current && current.id === ability.id}
                        onClick={() => act('select', { select: ability.id })}
                      />
                    ))
                  ) : (
                    <Box className="ds-dim">No abilities available.</Box>
                  )}
                </Section>
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
            <Button
              fluid
              color="caution"
              disabled={!canCast}
              onClick={() => act('cast', { cast: current?.id })}>
              {currentAbility && currentAbility.cooldown
                ? 'Cooling Down - ' + formatCooldown(currentAbility.cooldown)
                : 'Cast'}
            </Button>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
