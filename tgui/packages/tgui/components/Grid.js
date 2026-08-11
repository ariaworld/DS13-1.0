import { pureComponentHooks } from 'common/react';
import { Box } from './Box';

export const Grid = props => {
  const {
    columns,
    rows,
    gridSize,
    children,
    ...rest
  } = props;

  return (
    <Box
      style={{
        "display": "grid",
        "grid-template-columns": `repeat(${columns + 1}, ${gridSize})`,
        "grid-template-rows": `repeat(${rows + 1}, ${gridSize})`,
      }}
      {...rest}>
      {children}
    </Box>
  );
};

export const GridItem = props => {
  const {
    firstColumn,
    firstRow,
    secondColumn,
    secondRow,
    children,
    ...rest
  } = props;

  return (
    <Box
      style={{
        "position": "relative",
        "grid-column": `${firstColumn} / span ${Math.max(1, secondColumn || 1)}`,
        "grid-row": `${firstRow} / span ${Math.max(1, secondRow || 1)}`,
      }}
      {...rest}>
      {children}
    </Box>
  );
};

Grid.defaultHooks = pureComponentHooks;
GridItem.defaultHooks = pureComponentHooks;
Grid.Item = GridItem;
