import { Template } from './Template.stories'

export const ReadOnly = Template.bind({})

ReadOnly.args = {
  label: 'First Name',
  defaultValue: 'James Bond',
  readOnly: true,
}

ReadOnly.parameters = {
  docs: {
    storyDescription: 'Mark `TextBox` as read only using `readOnly` property.',
  },
}
