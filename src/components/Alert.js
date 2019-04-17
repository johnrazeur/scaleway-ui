import React from 'react'
import PropTypes from 'prop-types'
import { css } from '@emotion/core'
import { cx, sp, thColor } from 'utils'
import { Typography } from './Typography'
import { Icon, icons } from './Icon'

const style = ({ variant }) => p => css`
  display: flex;
  align-items: center;
  margin-bottom: ${sp(2)(p)};
  color: ${thColor(variant)(p)};
  font-weight: 700;
`

const variantIcons = {
  warning: 'alert',
  info: 'information-outline',
  success: 'check',
}

export const alertVariants = Object.keys(variantIcons)

export function Alert({ variant = 'warning', icon, children, ...props }) {
  return (
    <Typography css={cx(style({ variant }))} role="alert" {...props}>
      <Icon
        mr={2}
        name={icon || variantIcons[variant]}
        size={40}
        color={variant}
      />
      <span>{children}</span>
    </Typography>
  )
}

Alert.propTypes = {
  variant: PropTypes.oneOf(alertVariants),
  icon: PropTypes.oneOf(icons),
  children: PropTypes.node,
}
