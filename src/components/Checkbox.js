import React from 'react'
import PropTypes from 'prop-types'
import { css } from '@emotion/core'
import { SwitchState } from '@smooth-ui/core-em'
import { cx } from 'utils'
import {
  borderRadius,
  gray100,
} from 'theming'
import { ActivityIndicator } from './ActivityIndicator'
import { Icon } from './Icon'
import { Typography } from './Typography'
import { Box } from './Box'
import { Expandable } from './Expandable'

const styles = {
  container: css`
    position: relative;
    display: inline-flex;
    align-items: center;
  `,
  hover: p => css`
    &:hover {
      svg {
          border-radius: ${borderRadius(p)};
          background-color: ${!p.disabled && gray100(p)};
        }
      }
    }
  `,
  icon: css`
    box-sizing: content-box;
  `,
  input: css`
    cursor: pointer;
  `,
}

export function Checkbox({
  checked,
  defaultChecked,
  onChange,
  onFocus,
  onBlur,
  valid,
  error,
  name,
  value,
  size = 24,
  children,
  progress,
  id,
  disabled,
  typoVariant,
  ...props
}) {
  const hasChildren = Boolean(children)
  return (
    <SwitchState
      name={name}
      value={value}
      checked={checked}
      defaultChecked={defaultChecked}
      onChange={onChange}
      onFocus={onFocus}
      onBlur={onBlur}
    >
      {({ checked, input }) => (
        <Box {...props}>
          <Typography css={cx([styles.container, !disabled && styles.hover])}>
            {progress ? (
              <ActivityIndicator mr={hasChildren ? 1 : 0} />
            ) : (
              <Icon
                mr={hasChildren ? '10px' : 0}
                p="2px"
                css={cx(styles.icon)}
                name={
                  checked ? 'checkbox-marked-outline' : 'checkbox-blank-outline'
                }
                color={
                  disabled
                    ? 'gray100'
                    : valid === false || Boolean(error)
                    ? 'warning'
                    : valid === true
                    ? 'success'
                    : checked
                    ? 'primary'
                    : 'gray300'
                }
                size={size}
              />
            )}
            {hasChildren ? <span>{children}</span> : null}
            <input css={cx(!disabled && styles.input)} type="checkbox" {...input} id={id} disabled={disabled} />
          </Typography>
          <Expandable height={56} overflow="hidden" mt="-6px" opened={Boolean(error)}>
            <Box fontSize={12} color="warning" px="4px">{error}</Box>
          </Expandable>
        </Box>
      )}
    </SwitchState>
  )
}

Checkbox.propTypes = {
  valid: PropTypes.bool,
  progress: PropTypes.bool,
  size: PropTypes.number,
  children: PropTypes.node,
  error: PropTypes.string,
}

export default Checkbox
