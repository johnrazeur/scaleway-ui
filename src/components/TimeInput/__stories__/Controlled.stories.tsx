import { Story } from '@storybook/react'
import { useState } from 'react'
import TimeInput from '..'
import { SelectOption } from '../../RichSelect'

const isSafeValue = (value: unknown): value is SelectOption =>
  value !== null && !Array.isArray(value)

export const Controlled: Story = ({
  value: defaultValue = { label: '03:30', value: '03:30' },
}) => {
  const [value, setValue] = useState<SelectOption>(defaultValue as SelectOption)

  return (
    <TimeInput
      name="timeinput-test-controlled"
      onChange={newValue => {
        if (isSafeValue(newValue)) {
          setValue(newValue)
        }
      }}
      placeholder="Time"
      value={value}
    />
  )
}

Controlled.parameters = {
  docs: {
    storyDescription:
      'Most of the time, you need a [controlled component](https://reactjs.org/docs/forms.html).',
  },
}
